defmodule GeolocationServiceTest do
  use GeolocationService.DataCase

  alias GeolocationService.Repo
  alias GeolocationService.Schema.Geolocation

  test "fetch geolocation found" do
    Repo.insert!(%Geolocation{
      id: 73448,
      ip_address: "200.106.141.15",
      country_code: "SI",
      country: "Nepal",
      city: "DuBuquemouth",
      latitude: "-84.87503094689836",
      longitude: "7.206435933364332"
    })

    assert {:ok, geolocation} = GeolocationService.Impl.fetch_geolocation("200.106.141.15")
    assert %{ip_address: "200.106.141.15"} = geolocation
  end

  test "fetch geolocation not found" do
    assert {:error, :not_found} = GeolocationService.Impl.fetch_geolocation("200.106.141.15")
  end
end
