defmodule GeolocationService.Schema.Geolocation do
  use Ecto.Schema

  @parameters [:ip_address, :country_code, :country, :city, :latitude, :longitude]

  schema "geolocation" do
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
    |> Ecto.Changeset.validate_length(:ip_address, max: 15)
    |> Ecto.Changeset.validate_length(:country_code, is: 2)
    |> Ecto.Changeset.validate_length(:country, max: 40)
    |> Ecto.Changeset.validate_length(:city, max: 40)
    |> Ecto.Changeset.validate_length(:latitude, max: 20)
    |> Ecto.Changeset.validate_length(:longitude, max: 20)
  end
end
