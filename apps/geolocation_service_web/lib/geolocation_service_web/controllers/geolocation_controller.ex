defmodule GeolocationServiceWeb.GeolocationController do
  use GeolocationServiceWeb, :controller

  def show(conn, %{"ip_address" => ip_address}) do
    case fetch_geolocation(ip_address) do
      {:ok, geolocation} ->
        render(conn, "show.json", geolocation: geolocation)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> put_view(GeolocationServiceWeb.ErrorView)
        |> render("404.json")
    end
  end

  defp fetch_geolocation(ip_address) do
    GeolocationService.impl().fetch_geolocation(ip_address)
  end
end
