defmodule GeolocationService.Release do
  @moduledoc """
  Module with helper functions for migrating database during release
  """

  def migrate do
    ensure_started()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    ensure_started()

    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp ensure_started do
    Application.ensure_all_started(:ssl)
  end

  defp repos do
    Application.load(:geolocation_service)
    Application.fetch_env!(:geolocation_service, :ecto_repos)
  end
end
