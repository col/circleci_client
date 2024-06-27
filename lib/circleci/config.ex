defmodule CircleCI.Config do
  @default_server "https://circleci.com/api/v2"

  @default_stack [
    {CircleCI.Plugin.JasonSerializer, :encode_body, []},
    {CircleCI.Plugin.HTTPoisonClient, :request, []},
    {CircleCI.Plugin.JasonSerializer, :decode_body, []},
    {CircleCI.Plugin.TypedDecoder, :decode_response, []},
    {CircleCI.Plugin.TypedDecoder, :normalize_errors, []}
  ]

  @moduledoc """
  Configuration for the API client and plugins

  > #### Note {:.info}
  >
  > Functions in this module is unlikely to be used directly by applications. Instead, they are
  > useful for plugins. See `CircleCI.Plugin` for more information.

  Callers of API operation functions can pass in some configuration directly using the final
  argument. Configuration passed in this way always takes precedence over global configuration.

      # Local options:
      CircleCI.Workflow.get_workflow_by_id("workflow-123", server: "https://circleci.com/api/v2")

      # Application environment (ex. config/config.exs):
      config :circleci, server: "https://circleci.com/api/v2"

  ## Options

  The following configuration is available using **local options**:

    * `server` (URL): API server to use. Useful if the client would like to target a CircleCI
      Enterprise installation. Defaults to `#{@default_server}`.

    * `stack` (list of plugins): Plugins to control the execution of client requests. See
      `CircleCI.Plugin` for more information. Defaults to the default stack below.

    * `version` (string): API version to use. Setting this option is not recommended, as the default
      value is the version of the API used to generate this client's code. Overriding it risks the
      client raising an error. To see the default value, open `.api-version` in the root of this
      project.

    * `wrap` (boolean): Whether to wrap the results of the API call in a tagged tuple. When
      `true`, the response body will be wrapped as `{:ok, response}` on success or
      `{:error, error}` otherwise. When false, the Operation or Error is returned directly.
      Defaults to `true`.

      **Note**: Unwrapped responses violate the type specifications provided for each client
      operation. To avoid Dialyzer errors, consider using `CircleCI.raw/4` instead.

  The following configuration is available using the **application environment**:

    * `app_name` (string): Name of the application using this client, used for User Agent and
      logging purposes.

    * `default_auth` (`t:CircleCI.Auth.auth/0`): Default API authentication credentials to use when
      authentication was not provided for a request.

    * `server` (URL): API server to use. Defaults to `#{@default_server}`.

    * `stack` (list of plugins): Plugins to control the execution of client requests. See
      `CircleCI.Plugin` for more information. Defaults to the default stack below.

  ## Plugins

  Client requests are implemented using a series of plugins. Each plugin accepts a
  `CircleCI.Operation` struct and returns either a modified operation or an error. The collection of
  plugins configured for a request form a **stack**.

  The default stack uses `Jason` as a serializer/deserializer and `HTTPoison` as an HTTP client:

  ```elixir
  #{inspect(@default_stack, pretty: true, width: 98)}
  ```

  In general, plugins can be defined as 2- or 3-tuples specifying the module and function name and
  any options to pass to the function. For example:

      {MyPlugin, :my_function}
      #=> MyPlugin.my_function(operation)

      {MyPlugin, :my_function, some: :option}
      #=> MyPlugin.my_function(operation, some: :option)

  By modifying the stack, applications can easily use a different HTTP client library or serializer.

  > #### Warning {:.warning}
  >
  > Stack entries without options, like `{CircleCI.Plugin.TestClient, :request}`, look like keyword
  > list items. If you have stacks configured in multiple Mix environments that all use this
  > 2-tuple format, Elixir will try to merge them as keyword lists. Adding an empty options
  > element to any stack item will prevent this behaviour.
  """

  @typedoc """
  Plugin definition

  Plugins are defined in the stack using module and function tuples with an optional keyword list.
  Options, if provided, will be passed as the second argument.
  """
  @type plugin ::
          {module :: module, function :: atom, options :: keyword}
          | {module :: module, function :: atom}

  @doc """
  Get the configured app name

  ## Example

      iex> Config.app_name()
      "Test App"

  """
  @spec app_name :: String.t() | nil
  def app_name do
    Application.get_env(:circleci, :app_name)
  end

  @doc """
  Get the configured default auth credentials

  ## Example

      iex> Config.default_auth()
      {"client_one", "abc123"}

  """
  @spec default_auth :: CircleCI.Auth.auth()
  def default_auth do
    Application.get_env(:circleci, :default_auth)
  end

  @doc """
  Get the configured default API server, or `#{@default_server}` by default

  ## Example

      iex> Config.server([])
      "https://circleci.com/api/v2"

      iex> Config.server(server: "https://example.com/api/v2")
      "https://example.com/api/v2"

  """
  @spec server(keyword) :: String.t()
  def server(opts) do
    config(opts, :server, @default_server)
  end

  @doc """
  Get the configured plugin stack

  ## Example

      iex> Config.stack([])
      [
        {CircleCI.Plugin.JasonSerializer, :encode_body},
        # ...
      ]

  ## Default

  The following stack is the default if none is configured or passed as an option:

  ```elixir
  #{inspect(@default_stack, pretty: true, width: 98)}
  ```

  """
  @spec stack(keyword) :: [plugin]
  def stack(opts) do
    config(opts, :stack, @default_stack)
  end

  @doc """
  Whether to wrap the result

  Passing `wrap: false` to a client call can be useful if you need additional information about
  the response, such as response headers.

  ## Example

      iex> Config.wrap([])
      true

      iex> Config.wrap(wrap: false)
      false

  """
  @spec wrap(keyword) :: boolean
  def wrap(opts) do
    config(opts, :wrap, true)
  end

  #
  # Plugin Configuration
  #

  @doc """
  Get configuration namespaced with a plugin module

  Plugins can provide a keyword list of options (such as a pre-merged keyword list of the plugin
  options argument and the operation's options) to be used if the given key is present. Otherwise,
  the response will fall back to the application environment given with the following form:

      config :circleci, MyPlugin, some: :option

  Where `MyPlugin` is the `plugin` module given as the second argument.

  See `plugin_config!/3` for a variant that raises if the configuration is not found.
  """
  @spec plugin_config(keyword, module, atom, term) :: term
  def plugin_config(config \\ [], plugin, key, default) do
    if value = Keyword.get(config, key) do
      value
    else
      Application.get_env(:circleci, plugin, [])
      |> Keyword.get(key, default)
    end
  end

  @doc """
  Get configuration namespaced with a plugin module, or raise if not present

  Plugins can provide a keyword list of options (such as a pre-merged keyword list of the plugin
  options argument and the operation's options) to be used if the given key is present. Otherwise,
  the response will fall back to the application environment given with the following form:

      config :circleci, MyPlugin, some: :option

  Where `MyPlugin` is the `plugin` module given as the second argument.

  See `plugin_config/4` for a variant that accepts a default value.
  """
  @spec plugin_config!(keyword, module, atom) :: term | no_return
  def plugin_config!(config \\ [], plugin, key) do
    plugin_config(config, plugin, key, nil) ||
      raise "Configuration #{key} is required for #{plugin}"
  end

  #
  # Helpers
  #

  @spec config(keyword, atom, any) :: any
  defp config(config, key, default) do
    Keyword.get(config, key, Application.get_env(:circleci, key, default))
  end
end
