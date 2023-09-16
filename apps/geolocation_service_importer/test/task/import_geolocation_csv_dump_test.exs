defmodule GeolocationServiceImporter.Task.ImportGeolocationCSVDumpTest do
  use GeolocationServiceImporter.DataCase

  alias GeolocationService.Schema.Geolocation
  alias GeolocationServiceImporter.HTTPoisonMock
  alias GeolocationServiceImporter.ImportRepo
  alias GeolocationServiceImporter.Task.ImportGeolocationCSVDump

  import ExUnit.CaptureLog

  setup do
    System.put_env("CSV_URL", "www.test.com/file.csv")
    on_exit(fn -> System.delete_env("CSV_URL") end)
    Hammox.stub(HTTPoisonMock, :start, fn -> {:ok, [:ok]} end)

    Hammox.stub(HTTPoisonMock, :get!, fn _, _, _ ->
      body = """
      ip_address,country_code,country,city,latitude,longitude,mystery_value
      """

      %HTTPoison.Response{
        body: body,
        status_code: 200,
        request: %HTTPoison.Request{url: "www.test.com/file.csv"}
      }
    end)

    :ok
  end

  test "run task successfully" do
    Hammox.expect(HTTPoisonMock, :get!, fn _, _, _ ->
      body = """
      ip_address,country_code,country,city,latitude,longitude,mystery_value
      200.106.141.15,SI,Nepal,DuBuquemouth,-84.87503094689836,7.206435933364332,7823011346
      160.103.7.140,CZ,Nicaragua,New Neva,-68.31023296602508,-37.62435199624531,7301823115
      70.95.73.73,TL,Saudi Arabia,Gradymouth,-49.16675918861615,-86.05920084416894,2559997162
      ,PY,Falkland Islands (Malvinas),,75.41685191518815,-144.6943217219469,0
      125.159.20.54,LI,Guyana,Port Karson,-78.2274228596799,-163.26218895343357,1337885276
      """

      %HTTPoison.Response{
        body: body,
        status_code: 200,
        request: %HTTPoison.Request{url: "www.test.com/file.csv"}
      }
    end)

    ImportGeolocationCSVDump.run()

    geolocations = ImportRepo.all(Geolocation)

    assert ["125.159.20.54", "160.103.7.140", "200.106.141.15", "70.95.73.73"] ==
             Enum.map(geolocations, & &1.ip_address) |> Enum.sort()
  end

  test "task overrides duplicates" do
    Hammox.expect(HTTPoisonMock, :get!, fn _, _, _ ->
      body = """
      ip_address,country_code,country,city,latitude,longitude,mystery_value
      200.106.141.15,SI,Nepal,DuBuquemouth,-84.87503094689836,7.206435933364332,7823011346
      """

      %HTTPoison.Response{
        body: body,
        status_code: 200,
        request: %HTTPoison.Request{url: "www.test.com/file.csv"}
      }
    end)

    ImportGeolocationCSVDump.run()

    Hammox.expect(HTTPoisonMock, :get!, fn _, _, _ ->
      body = """
      ip_address,country_code,country,city,latitude,longitude,mystery_value
      200.106.141.15,CZ,Nicaragua,New Neva,-68.31023296602508,-37.62435199624531,7301823115
      """

      %HTTPoison.Response{
        body: body,
        status_code: 200,
        request: %HTTPoison.Request{url: "www.test.com/file.csv"}
      }
    end)

    ImportGeolocationCSVDump.run()

    geolocations = ImportRepo.all(Geolocation)

    assert ["CZ"] ==
             Enum.map(geolocations, & &1.country_code)
  end

  test "task skips entities with missing values" do
    Hammox.expect(HTTPoisonMock, :get!, fn _, _, _ ->
      body = """
      ip_address,country_code,country,city,latitude,longitude,mystery_value
      200.106.141.15,SI,,DuBuquemouth,-84.87503094689836,7.206435933364332,7823011346
      """

      %HTTPoison.Response{
        body: body,
        status_code: 200,
        request: %HTTPoison.Request{url: "www.test.com/file.csv"}
      }
    end)

    ImportGeolocationCSVDump.run()

    geolocations = ImportRepo.all(Geolocation)
    assert [] == Enum.map(geolocations, & &1.country_code)
  end

  test "task prints how long it took to import the file" do
    Hammox.expect(HTTPoisonMock, :get!, fn _, _, _ ->
      body = """
      ip_address,country_code,country,city,latitude,longitude,mystery_value
      200.106.141.15,SI,Test,DuBuquemouth,-84.87503094689836,7.206435933364332,7823011346
      200.106.141.15,SI,,DuBuquemouth,-84.87503094689836,7.206435933364332,7823011346
      """

      %HTTPoison.Response{
        body: body,
        status_code: 200,
        request: %HTTPoison.Request{url: "www.test.com/file.csv"}
      }
    end)

    {:ok, log} = with_log(fn -> ImportGeolocationCSVDump.run() end)

    assert log =~ "Completed in "
    assert log =~ "seconds"
    assert log =~ "1 accepted values"
    assert log =~ "1 rejected values"
  end

  test "filters duplicates in one batch to avoid insert crash" do
    Hammox.expect(HTTPoisonMock, :get!, fn _, _, _ ->
      body = """
      ip_address,country_code,country,city,latitude,longitude,mystery_value
      200.106.141.15,SI,Test,DuBuquemouth,-84.87503094689836,7.206435933364332,7823011346
      200.106.141.15,SI,Test,DuBuquemouth,-84.87503094689836,7.206435933364332,7823011346
      """

      %HTTPoison.Response{
        body: body,
        status_code: 200,
        request: %HTTPoison.Request{url: "www.test.com/file.csv"}
      }
    end)

    ImportGeolocationCSVDump.run()

    geolocations = ImportRepo.all(Geolocation)
    assert [_] = Enum.map(geolocations, & &1.country_code)
  end

  test "calculates counters correctly when rejected for duplication" do
    Hammox.expect(HTTPoisonMock, :get!, fn _, _, _ ->
      body = """
      ip_address,country_code,country,city,latitude,longitude,mystery_value
      200.106.141.15,SI,Test,DuBuquemouth,-84.87503094689836,7.206435933364332,7823011346
      200.106.141.15,SI,Test,DuBuquemouth,-84.87503094689836,7.206435933364332,7823011346
      """

      %HTTPoison.Response{
        body: body,
        status_code: 200,
        request: %HTTPoison.Request{url: "www.test.com/file.csv"}
      }
    end)

    {:ok, log} = with_log(fn -> ImportGeolocationCSVDump.run() end)

    assert log =~ "1 accepted values"
    assert log =~ "1 rejected values"

    geolocations = ImportRepo.all(Geolocation)
    assert [_] = Enum.map(geolocations, & &1.country_code)
  end
end
