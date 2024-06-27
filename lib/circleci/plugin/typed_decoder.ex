defmodule CircleCI.Plugin.TypedDecoder do
  @moduledoc """
  Transform map responses into well-typed structs

  In a normal client stack, the HTTP request is followed by a JSON decoder such as
  `CircleCI.Plugin.JasonSerializer`. If the JSON library/plugin does not support decoding typed
  structs, then a separate step is necessary to transform the map responses into structs like
  `CircleCI.Workflow`.

  This module provides a two plugins: `decode_response/2` and `normalize_errors/2`, that accept no
  configuration. `decode_response/2` uses the type information available in the operation and each
  module's `__fields__/1` functions to decode the data. `normalize_errors/2` changes API error
  responses into standard `CircleCI.Error` results. It is recommended to run these plugins towards
  the end of the stack, after decoding JSON responses.

  The normalized errors will be `CircleCI.Error` structs with relevant reason fields where possible.

  ## Special Cases

  There are a few special cases where the decoder must make an inference about which type to use.
  If you find that you are unable to decode something, please open an issue with information about
  the operation and types involved.

  Union types often require this kind of inference. This module handles them on a case-by-case
  basis using required keys to determine the correct type. Some of these are done on a "best
  guess" basis due to a lack of official documentation.
  """
  alias CircleCI.Error
  alias CircleCI.Operation

  @doc """
  Decode a response body based on type information from the operation and schemas
  """
  @spec decode_response(Operation.t(), keyword) :: {:ok, Operation.t()}
  def decode_response(operation, _opts) do
    %Operation{response_body: body, response_code: code, response_types: types} = operation

    case get_type(types, code) do
      {:ok, response_type} ->
        decoded_body = do_decode(body, response_type)
        {:ok, %Operation{operation | response_body: decoded_body}}

      {:error, :not_found} ->
        {:ok, operation}
    end
  end

  defp get_type(types, code) do
    if res = Enum.find(types, fn {c, _} -> c == code end) do
      {:ok, elem(res, 1)}
    else
      {:error, :not_found}
    end
  end

  @doc """
  Manually decode a response

  This function takes a parsed response and decodes it using the given type. It is intended for
  use in testing scenarios only. For regular API requests, use `decode_response/2` as part of the
  client stack.
  """
  @spec decode(term, Operation.type()) :: term
  def decode(response, type) do
    do_decode(response, type)
  end

  defp do_decode(nil, _), do: nil
  defp do_decode("", :null), do: nil
  defp do_decode(value, {:string, :date}), do: Date.from_iso8601!(value)
  defp do_decode(value, {:string, :date_time}), do: DateTime.from_iso8601(value) |> elem(1)
  defp do_decode(value, {:string, :time}), do: Time.from_iso8601!(value)
  defp do_decode(value, {:union, types}), do: do_decode(value, choose_union(value, types))

  defp do_decode(value, [type]), do: Enum.map(value, &do_decode(&1, type))

  defp do_decode(%{} = value, {module, type}) do
    base = if function_exported?(module, :__struct__, 0), do: struct(module), else: %{}
    fields = module.__fields__(type)

    for {field_name, field_type} <- fields, reduce: base do
      decoded_value ->
        case Map.fetch(value, to_string(field_name)) do
          {:ok, field_value} ->
            decoded_field_value = do_decode(field_value, field_type)
            Map.put(decoded_value, field_name, decoded_field_value)

          :error ->
            decoded_value
        end
    end
  end

  defp do_decode(value, _type), do: value

  @doc """
  Change API error responses into `CircleCI.Error` results
  """
  @spec normalize_errors(Operation.t(), keyword) :: {:ok, Operation.t()} | {:error, Error.t()}
  def normalize_errors(%Operation{response_code: code} = operation, _opts) when code >= 400 do
    %Operation{response_body: body} = operation

    error_attributes =
      Keyword.merge(
        [
          code: code,
          operation: operation,
          source: body,
          step: {__MODULE__, :normalize_errors}
        ],
        error_attributes(code, body)
      )

    {:error, Error.new(error_attributes)}
  end

  def normalize_errors(operation, _opts), do: {:ok, operation}

  @spec error_attributes(integer | nil, any) :: keyword

  # Not found
  defp error_attributes(404, _response) do
    [message: "Not Found", reason: :not_found]
  end

  defp error_attributes(_code, %{"message" => message}), do: [message: message]
  defp error_attributes(_code, %{message: message}), do: [message: message]
  defp error_attributes(_code, _response), do: [message: "Unknown Error"]

  #
  # Union Type Handlers
  #

  defp choose_union(nil, [_type, :null]), do: :null
  defp choose_union(nil, [:null, _type]), do: :null
  defp choose_union(_value, [type, :null]), do: type
  defp choose_union(_value, [:null, type]), do: type

  defp choose_union(%{}, [:map, {:string, :generic}]), do: :map
  defp choose_union(_value, [:map, {:string, :generic}]), do: {:string, :generic}

  defp choose_union(value, [:number, {:string, :generic}]) when is_number(value), do: :number
  defp choose_union(_value, [:number, {:string, :generic}]), do: :string

  defp choose_union(value, [{:string, :generic}, [string: :generic]]) do
    cond do
      is_list(value) -> [string: :generic]
      is_binary(value) -> {:string, :generic}
    end
  end

  defp choose_union(value, [:integer, {:string, :generic}, [string: :generic], :null]) do
    cond do
      is_nil(value) -> :null
      is_integer(value) -> :integer
      is_binary(value) -> {:string, :generic}
      is_list(value) -> [string: :generic]
    end
  end

  defp choose_union(value, [
         :map,
         {:string, :generic},
         [{:string, :generic}]
       ]) do
    cond do
      is_binary(value) -> {:string, :generic}
      is_map(value) -> :map
      is_list(value) -> [{:string, :generic}]
    end
  end

  defp choose_union(value, [
         :map,
         {:string, :generic},
         [:map],
         [{:string, :generic}]
       ]) do
    cond do
      is_binary(value) ->
        {:string, :generic}

      is_map(value) ->
        :map

      is_list(value) ->
        case value do
          [%{} | _] -> [:map]
          _else -> [{:string, :generic}]
        end
    end
  end

  defp choose_union(_value, types) do
    raise "TypedDecoder: Unable to decode union type #{inspect(types)}; not implemented"
  end
end
