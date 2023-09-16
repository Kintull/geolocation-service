defmodule GeolocationServiceImporter.ImportRepo do
  use Ecto.Repo,
    otp_app: :geolocation_service_importer,
    adapter: Ecto.Adapters.Postgres
end
