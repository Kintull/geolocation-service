defmodule GeolocationServiceWeb.Router do
  use GeolocationServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GeolocationServiceWeb do
    pipe_through :api

    get "/geolocation/:ip_address", GeolocationController, :show
  end
end
