# Circle API Client for Elixir

[![Hex.pm](https://img.shields.io/hexpm/v/circleci_client)](https://hex.pm/packages/circleci_client)
[![Documentation](https://img.shields.io/badge/hex-docs-blue)](https://hexdocs.pm/circleci_client)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](CODE_OF_CONDUCT.md)

_The ergonomics of a hand-crafted client with the API coverage of generated code._

---

This library uses an [OpenAPI Code Generator](https://github.com/aj-foster/open-api-generator) that has the flexibility to wrangle the generated code into an ergonomic client.

Furthermore, this library has no opinions about what you use for HTTP requests, serialization, etc.
Instead it allows users to define their own **stack** of plugins, many of which are provided here.

## Installation

This library is available on Hex.pm.
Add the dependency in `mix.exs`:

```elixir
def deps do
  [
    {:circleci_client, "~> 0.1.0"}
  ]
end
```

Then install the dependency using `mix deps.get`.

## Configuration

This library comes with a common default set of configuration.
To use it successfully, you will need to install `HTTPoison` and `Jason`.
(Remember, these libraries can easily be switched out by changing the `stack` configuration.
See `CircleCI.Config` for more information.)

Some good up-and-running configuration to set:

* `app_name` will include the name of your application in the User Agent so CircleCI can contact you if they notice any problems.

```elixir
config :circleci,
  app_name: "MyApp"
```

For more information about configuration, see the documentation for `CircleCI.Config`.

## Usage

All of the client operations are generated based on the OpenAPI description provided by CircleCI.
In general, you can expect to find:

```elixir
CircleCI.Resource.operation(path1, path2, ..., body, opts)
```

Where:

* `Resource` is the name of the resource as tagged by CircleCI, like `Workflow`.
* `operation` is the name of the route, like `get` or `get_workflow_by_id`.
* The first arguments are path parameters, such as `workflow_id` in `/workflow/{workflow_id}`.
* If the request accepts a body, then there will be a `body` parameter.
* Finally, all operations accept a keyword list of options.

The options accepted by operations may differ depending on your chosen stack.
However, the following are always available:

* `auth` (string or struct implementing `CircleCI.Auth`) Credentials to use for the request.
* `server` (URL including scheme) Base API server to use, such as `https://circleci.com/api/v2`.

Whenever CircleCI specifies a named schema as the response type for an operation, an Elixir struct will be returned.
Note that some schemas have been collapsed into a single struct (like `CircleCI.Workflow`) where not all of the fields may be filled in.
However, responses are still properly typed by their type specifications.

## Contributing

Because this library uses a code generator for the majority of its mass, there are two modes of contribution.
Please consider these when creating issues or opening pull requests:

* If the generated code is out of date, the fix may be as simple as running `mix gen.api` using the latest OpenAPI description.
* If the client isn't working as expected, the fix may be more involved and require careful thought and versioning.

For more on what this means to you as a contributor, please see the [contribution guidelines](CONTRIBUTING.md).
