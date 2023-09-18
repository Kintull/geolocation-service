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

  test "validating format IP address" do
    changeset = Geolocation.changeset(%{ip_address: String.duplicate("A", 15)})
    [ip_address: {"has invalid format", [validation: :format]}] in changeset.errors

    changeset = Geolocation.changeset(%{ip_address: "aaa.1.1.1"})
    [ip_address: {"has invalid format", [validation: :format]}] in changeset.errors

    changeset = Geolocation.changeset(%{ip_address: "a1.1.1.1b"})
    [ip_address: {"has invalid format", [validation: :format]}] in changeset.errors
  end

  test "validating longitude" do
    changeset = Geolocation.changeset(%{longitude: "a1.11b"})
    [longitude: {"has invalid format", [validation: :format]}] in changeset.errors

    changeset = Geolocation.changeset(%{longitude: "a.11"})
    [longitude: {"has invalid format", [validation: :format]}] in changeset.errors

    changeset = Geolocation.changeset(%{longitude: "1.aa"})
    [longitude: {"has invalid format", [validation: :format]}] in changeset.errors

    changeset = Geolocation.changeset(%{longitude: ".11"})
    [longitude: {"has invalid format", [validation: :format]}] in changeset.errors

    changeset = Geolocation.changeset(%{longitude: "1234.11"})
    [longitude: {"has invalid format", [validation: :format]}] in changeset.errors

    changeset = Geolocation.changeset(%{longitude: "1,11"})
    [longitude: {"has invalid format", [validation: :format]}] in changeset.errors
  end

  test "validating latitude" do
    changeset = Geolocation.changeset(%{latitude: "a1.11b"})
    [latitude: {"has invalid format", [validation: :format]}] in changeset.errors

    changeset = Geolocation.changeset(%{latitude: "a.11"})
    [latitude: {"has invalid format", [validation: :format]}] in changeset.errors

    changeset = Geolocation.changeset(%{latitude: "1.aa"})
    [latitude: {"has invalid format", [validation: :format]}] in changeset.errors

    changeset = Geolocation.changeset(%{latitude: ".11"})
    [latitude: {"has invalid format", [validation: :format]}] in changeset.errors

    changeset = Geolocation.changeset(%{latitude: "123.11"})
    [latitude: {"has invalid format", [validation: :format]}] in changeset.errors

    changeset = Geolocation.changeset(%{latitude: "1,11"})
    [latitude: {"has invalid format", [validation: :format]}] in changeset.errors
  end

  test "validating country code" do
    changeset = Geolocation.changeset(%{country_code: "ABC"})
    [country_code: {"has invalid format", [validation: :format]}] in changeset.errors

    changeset = Geolocation.changeset(%{country_code: "A"})
    [country_code: {"has invalid format", [validation: :format]}] in changeset.errors

    changeset = Geolocation.changeset(%{country_code: "A5"})
    [country_code: {"has invalid format", [validation: :format]}] in changeset.errors

    changeset = Geolocation.changeset(%{country_code: "55"})
    [country_code: {"has invalid format", [validation: :format]}] in changeset.errors
  end
end
