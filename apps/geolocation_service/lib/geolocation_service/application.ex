defmodule GeolocationService.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      GeolocationService.Repo
      # Start the PubSub system
      #      {Phoenix.PubSub, name: GeolocationService.PubSub}
      # Start a worker by calling: GeolocationService.Worker.start_link(arg)
      # {GeolocationService.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: GeolocationService.Supervisor)
  end
end
