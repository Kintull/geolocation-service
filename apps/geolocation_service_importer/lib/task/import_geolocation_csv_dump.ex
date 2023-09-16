defmodule GeolocationServiceImporter.Task.ImportGeolocationCSVDump do
  @moduledoc """
  This task imports geolocation data from a csv file.
  It is designed to run as a cron job.

  Task configuration:
      CSV_URL - string; location of a dump file
      WRITE_BATCH_SIZE - integer; default 1000
      WRITE_SLEEP_MS - integer; sleeping time between writes in milisecond; default 200
  """

  @http_adapter Application.compile_env!(:geolocation_service_importer, :http_adapter)

  require Logger

  alias GeolocationService.Schema.Geolocation
  alias GeolocationServiceImporter.ImportRepo

  def run() do
    write_batch_size = System.get_env("WRITE_BATCH_SIZE", "1000") |> String.to_integer()
    write_sleep_ms = System.get_env("WRITE_SLEEP_MS", "200") |> String.to_integer()
    csv_url = System.fetch_env!("CSV_URL")

    {:ok, accepted_agent} = Agent.start_link(fn -> 0 end)
    {:ok, rejected_agent} = Agent.start_link(fn -> 0 end)

    {execution_time_msec, _} =
      :timer.tc(fn ->
        csv_url
        |> fetch_csv()
        |> decode_csv(rejected_agent)
        |> persist_entities(
          batch_size: write_batch_size,
          write_sleep_ms: write_sleep_ms,
          accepted_agent: accepted_agent,
          rejected_agent: rejected_agent
        )
      end)

    count_accepted = get_counter(accepted_agent)
    count_rejected = get_counter(rejected_agent)
    execution_time_min = round(execution_time_msec / 1_000 / 60)

    Logger.info(
      "Completed in #{execution_time_min} seconds. " <>
        "#{count_accepted} accepted values. " <>
        "#{count_rejected} rejected values.",
      %{
        execution_time_msec: execution_time_msec,
        count_accepted: count_accepted,
        count_rejected: count_rejected
      }
    )
  end

  defp fetch_csv(url) do
    @http_adapter.start()

    %HTTPoison.Response{status_code: 200, body: body} =
      @http_adapter.get!(
        url,
        %{},
        follow_redirect: true
      )

    body
  end

  def decode_csv(csv_body, rejected_agent) do
    csv_body
    |> String.trim()
    |> String.splitter("\n")
    |> CSV.decode!(headers: true, field_transform: &String.trim/1)
    |> Stream.reject(fn values ->
      !is_valid?(build_parameters(values)) && increment_counter(rejected_agent)
    end)
    |> Stream.map(fn values -> build_parameters(values) end)
  end

  defp build_parameters(values) do
    %{
      country: values["country"],
      country_code: values["country_code"],
      ip_address: values["ip_address"],
      city: values["city"],
      latitude: values["latitude"],
      longitude: values["longitude"],
      inserted_at: DateTime.utc_now() |> DateTime.truncate(:second),
      updated_at: DateTime.utc_now() |> DateTime.truncate(:second)
    }
  end

  defp is_valid?(params) do
    match?(%{valid?: true}, Geolocation.changeset(params))
  end

  defp persist_entities(
         geolocation_entity_params,
         batch_size: write_batch_size,
         write_sleep_ms: write_sleep_ms,
         accepted_agent: accepted_agent,
         rejected_agent: rejected_agent
       ) do
    Ecto.Migrator.with_repo(ImportRepo, fn _ ->
      geolocation_entity_params
      |> Stream.chunk_every(write_batch_size)
      |> Enum.each(fn batch ->
        batch = filter_and_count_duplicates(batch, accepted_agent, rejected_agent)

        ImportRepo.insert_all(Geolocation, batch,
          on_conflict: :replace_all,
          conflict_target: :ip_address
        )

        Process.sleep(write_sleep_ms)
      end)
    end)
  end

  defp filter_and_count_duplicates(geolocation_entity_params, accepted_agent, rejected_agent) do
    unique_results = Enum.uniq_by(geolocation_entity_params, fn %{ip_address: ip} -> ip end)
    accepted_count = length(unique_results)
    rejected_count = length(geolocation_entity_params) - accepted_count
    increment_counter(accepted_agent, accepted_count)
    increment_counter(rejected_agent, rejected_count)
    unique_results
  end

  defp increment_counter(agent, counter \\ 1) do
    Agent.update(agent, &(&1 + counter))
  end

  defp get_counter(agent) do
    Agent.get(agent, & &1)
  end
end
