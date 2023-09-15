defmodule GeolocationService.Repo.Migrations.AddGeolocations do
  use Ecto.Migration

  def change do
    create table("geolocations") do
      add :ip_address, :string, size: 16
      add :country_code, :string, size: 2
      add :country, :string, size: 40
      add :city, :string, size: 40
      add :latitude, :string, size: 20
      add :longitude, :string, size: 20

      timestamps()
    end

    create unique_index(:geolocations, [:ip_address], concurrenly: true)
  end
end
