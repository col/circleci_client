import Config

config :oapi_generator, default: [
  output: [
    base_module: CircleCI,
    location: "lib",
    operation_subdirectory: "operations/",
    schema_subdirectory: "schemas/",
  ]
]