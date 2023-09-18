defmodule GeolocationService.Repo.Migrations.ExpandCountryColumn do
  use Ecto.Migration

  def change do
    alter table("geolocations") do
      modify :country, :string, size: 100
    end
  end
end
