defmodule GeolocationServiceWeb.GeolocationView do
  use GeolocationServiceWeb, :view

  def render("show.json", %{geolocation: geolocation}) do
    %{
      ip_address: geolocation.ip_address,
      country_code: geolocation.country_code,
      country: geolocation.country,
      city: geolocation.city,
      latitude: geolocation.latitude,
      longitude: geolocation.longitude
    }
  end
end
