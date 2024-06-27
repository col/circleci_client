if Mix.env() == :dev do
  defmodule CircleCI.Processor do
    @moduledoc false
    use OpenAPI.Processor

    def operation_docstring(state, operation_spec, params) do
      OpenAPI.Processor.Operation.docstring(state, operation_spec, params)
      |> String.replace("](/", "](https://circleci.com/docs/api/v2/")
    end
  end
end
