defmodule GeolocationService.Schema.Geolocation do
  @moduledoc """
  This entity represents geolocation of a particular IP address
  """
  use Ecto.Schema
  @timestamps_opts [type: :utc_datetime]

  @parameters [:ip_address, :country_code, :country, :city, :latitude, :longitude]

  @type t :: %__MODULE__{}

  schema "geolocations" do
    field :ip_address, :binary
    field :country_code, :binary
    field :country, :binary
    field :city, :binary
    field :latitude, :binary
    field :longitude, :binary

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> Ecto.Changeset.cast(params, @parameters)
    |> Ecto.Changeset.validate_length(:ip_address, min: 1, max: 15)
    |> Ecto.Changeset.validate_length(:country_code, is: 2)
    |> Ecto.Changeset.validate_length(:country, min: 1, max: 40)
    |> Ecto.Changeset.validate_length(:city, min: 1, max: 40)
    |> Ecto.Changeset.validate_length(:latitude, min: 1, max: 20)
    |> Ecto.Changeset.validate_length(:longitude, min: 1, max: 20)
    |> Ecto.Changeset.validate_required(@parameters)
  end
end
