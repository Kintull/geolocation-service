import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :geolocation_service, GeolocationService.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "geolocation_service_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :geolocation_service_importer, GeolocationServiceImporter.ImportRepo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "geolocation_service_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :geolocation_service_web, GeolocationServiceWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "bDSNNICgtO/BI6uFIuhEq3734PAZj/Lqxx5un5qICI8Q48pj0IWBe5hVayJHhHur",
  server: false

# Print only warnings and errors during test
config :logger, level: :info

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :geolocation_service_importer, :http_adapter, GeolocationServiceImporter.HTTPoisonMock
config :geolocation_service, :geolocation_service_impl, GeolocationServiceMock
