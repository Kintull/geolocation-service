defmodule GeolocationServiceWeb.GeolocationControllerTest do
  use GeolocationServiceWeb.ConnCase

  alias GeolocationService.Schema.Geolocation

  test "GET /geolocation/:ip_address found", %{conn: conn} do
    Hammox.expect(GeolocationService.impl(), :fetch_geolocation, fn _ip ->
      {:ok,
       %Geolocation{
         id: 73_448,
         ip_address: "200.106.141.15",
         country_code: "SI",
         country: "Nepal",
         city: "DuBuquemouth",
         latitude: "-84.87503094689836",
         longitude: "7.206435933364332"
       }}
    end)

    conn = get(conn, "/geolocation/200.106.141.15")

    assert json_response(conn, 200) == %{
             "city" => "DuBuquemouth",
             "country" => "Nepal",
             "country_code" => "SI",
             "ip_address" => "200.106.141.15",
             "latitude" => "-84.87503094689836",
             "longitude" => "7.206435933364332"
           }
  end

  test "GET /geolocation/:ip_address 404 not found", %{conn: conn} do
    Hammox.expect(GeolocationService.impl(), :fetch_geolocation, fn _ip ->
      {:error, :not_found}
    end)

    conn = get(conn, "/geolocation/200.106.141.15")

    assert json_response(conn, 404) == %{"error" => "not found"}
  end
end
