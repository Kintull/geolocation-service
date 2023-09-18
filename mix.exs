defmodule GeolocationService.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      releases: [
        geolocation_service_importer: [
          applications: [
            geolocation_service_importer: :permanent,
            geolocation_service: :permanent
          ]
        ],
        geolocation_service_web: [
          applications: [
            geolocation_service_web: :permanent,
            geolocation_service: :permanent
          ]
        ],
        geolocation_service_migrator: [
          applications: [
            geolocation_service: :permanent
          ]
        ]
      ]
    ]
  end

  defp deps do
    [{:credo, "~> 1.7", only: [:dev, :test], runtime: false}]
  end

  defp aliases do
    [
      setup: ["cmd mix setup"]
    ]
  end
end
