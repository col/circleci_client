defmodule CircleciClient.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/challengr-apps/circleci_client"

  def project do
    [
      app: :circleci_client,
      version: @version,
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      name: "CircleCI API Client",
      source_url: @source_url,
      homepage_url: @source_url,
      deps: deps(),
      docs: docs(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    if Mix.env() == :prod do
      [
        extra_applications: [:logger]
      ]
    else
      [
        extra_applications: [:logger, :hackney]
      ]
    end
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.29", only: :dev, runtime: false},
      {:faker, "~> 0.15"},
      {:jason, "~> 1.0", optional: true},
      {:httpoison, "~> 1.7 or ~> 2.0", optional: true},
      {:oapi_generator, github: "aj-foster/open-api-generator", only: :dev, runtime: false},
      {:opentelemetry_api, "~> 1.0", optional: true},
      {:opentelemetry_semantic_conventions, "~> 0.2", optional: true},
      {:plug, "~> 1.0", optional: true},
      {:telemetry, "~> 0.4.2 or ~> 1.0"}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: [
        "README.md": [title: "Overview"],
        "CODE_OF_CONDUCT.md": [title: "Code of Conduct"],
        "CONTRIBUTING.md": [title: "Contributing"],
        LICENSE: [title: "License"]
      ],
      groups_for_modules: [
        Client: [
          CircleCI,
          CircleCI.Auth,
          CircleCI.Config,
          CircleCI.Error,
          CircleCI.Operation
        ],
        Testing: [
          ~r/CircleCI.Testing/,
          CircleCI.Plugin.TestClient
        ],
        Plugins: ~r/CircleCI.Plugin/,
        Operations: [
          CircleCI.Job,
          CircleCI.Pipeline,
          CircleCI.Workflow
        ],
        Schemas: ~r//
      ]
    ]
  end
  
  defp package do
    [
      description: "CircleCI API Client for Elixir",
      files: [
        ".formatter.exs",
        "lib",
        "LICENSE",
        "mix.exs",
        "README.md"
      ],
      licenses: ["MIT"],
      links: %{"CircleCI" => @source_url},
      maintainers: ["Colin Harris"]
    ]
  end
end
