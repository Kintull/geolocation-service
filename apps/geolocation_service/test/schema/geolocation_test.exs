defmodule GeolocationService.Schema.GeolocationTest do
  alias GeolocationService.Schema.Geolocation

  use ExUnit.Case

  test "valid changeset" do
    assert %Ecto.Changeset{valid?: true} =
             Geolocation.changeset(%{
               ip_address: "111.111.111.111",
               country_code: "CA",
               country: "Canada",
               city: "Quebec",
               latitude: "73.00000001",
               longitude: "-132.00000001"
             })
  end

  test "invalid changeset" do
    assert %Ecto.Changeset{valid?: false} =
             Geolocation.changeset(%{ip_address: "111.111.111.1111"})

    assert %Ecto.Changeset{valid?: false} = Geolocation.changeset(%{ip_address: ""})
    assert %Ecto.Changeset{valid?: false} = Geolocation.changeset(%{country_code: "CAD"})
    assert %Ecto.Changeset{valid?: false} = Geolocation.changeset(%{country_code: "C"})

    assert %Ecto.Changeset{valid?: false} =
             Geolocation.changeset(%{country_code: String.duplicate("A", 41)})

    assert %Ecto.Changeset{valid?: false} = Geolocation.changeset(%{country_code: ""})

    assert %Ecto.Changeset{valid?: false} =
             Geolocation.changeset(%{city: String.duplicate("A", 41)})

    assert %Ecto.Changeset{valid?: false} = Geolocation.changeset(%{city: ""})

    assert %Ecto.Changeset{valid?: false} =
             Geolocation.changeset(%{latitude: String.duplicate("A", 21)})

    assert %Ecto.Changeset{valid?: false} = Geolocation.changeset(%{latitude: ""})

    assert %Ecto.Changeset{valid?: false} =
             Geolocation.changeset(%{longitude: String.duplicate("A", 21)})

    assert %Ecto.Changeset{valid?: false} = Geolocation.changeset(%{longitude: ""})
  end
end
