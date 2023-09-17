defmodule GeolocationService.Impl do
  @moduledoc false

  alias GeolocationService.Repo
  alias GeolocationService.Schema.Geolocation

  @behaviour GeolocationService

  @impl true
  def fetch_geolocation(ip_address) do
    case Repo.get_by(Geolocation, ip_address: ip_address) do
      nil -> {:error, :not_found}
      geolocation -> {:ok, geolocation}
    end
  end
end
