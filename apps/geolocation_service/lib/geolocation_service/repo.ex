defmodule GeolocationService.Repo do
  use Ecto.Repo,
    otp_app: :geolocation_service,
    adapter: Ecto.Adapters.Postgres
end
