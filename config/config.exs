# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configure Mix tasks and generators
config :geolocation_service,
  ecto_repos: [GeolocationService.Repo]

config :geolocation_service_importer,
  ecto_repos: [GeolocationServiceImporter.ImportRepo]

# config :geolocation_service_web, ecto_repos: []

# Configures the endpoint
config :geolocation_service_web, GeolocationServiceWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    view: GeolocationServiceWeb.ErrorView,
    format: "json",
    accepts: ~w(json),
    layout: false
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :geolocation_service_importer, :http_adapter, HTTPoison
config :geolocation_service, :geolocation_service_impl, GeolocationService.Impl

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
