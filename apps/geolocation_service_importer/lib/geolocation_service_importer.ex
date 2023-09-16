defmodule GeolocationServiceImporter do
  @moduledoc """
  Entry point for importing geolocation data.
  """

  require Logger

  alias GeolocationServiceImporter.Task.ImportGeolocationCSVDump

  def import_geolocation_csv_dump do
    Logger.info("Task GeolocationServiceImporter.import_geolocation_csv_dump() started")

    {:ok, _} = Application.ensure_all_started(:geolocation_service, :permanent)

    ImportGeolocationCSVDump.run()

    Logger.info("Task GeolocationServiceImporter.import_geolocation_csv_dump() ended")
  end
end
