defmodule GeolocationService do
  @moduledoc """
  GeolocationService keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @implementation Application.compile_env(:geolocation_service, :geolocation_service_impl)

  def impl(), do: @implementation

  alias GeolocationService.Schema.Geolocation

  @type ip_address :: String.t()

  @callback fetch_geolocation(ip_address()) :: {:ok, Geolocation.t()} | {:error, :not_found}
end
