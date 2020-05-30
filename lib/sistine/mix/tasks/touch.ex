defmodule Mix.Tasks.Touch do
  @moduledoc """
  Touches a table by updating id=id. 
  This doesn't change any data, but it causes the wrote to be written to the WAL and
  restreamed out to anyone subscribing to the WAL. 

  Example: 

  `$ mix touch --table <table> --repo <repo_name>`
  `$ mix touch --table paintings --repo Sistine.Repo`
  """

  use Mix.Task
  require Logger

  import Ecto.Query, warn: false

  @switches [
    table: :string,
    repo: :string
  ]

  @vacuum_percentage 0.05

  def run(args) do
    Mix.Task.run("app.start")

    {switch_vals, _non_switch, _invalid} = OptionParser.parse(args, switches: @switches)
    Logger.info("Starting Touch with these args: #{inspect(switch_vals)}")

    switch_vals
    |> Enum.into(%{})
    |> process
  end

  defp process(%{table: table, repo: string_repo} = _) do
    repo = get_repo(string_repo)
    settings = get_settings(table, repo)

    Logger.info("Repo: #{inspect(repo)}")
    Logger.info("Settings: #{inspect(settings)}")

    # Clean the table before starting
    vacuum(table, repo)

    Enum.reduce(0..settings[:num_batches], 0, fn x, dirty ->
      Logger.info("Running batch: #{x}")

      min_id = x * settings[:per_batch]
      max_id = (x + 1) * settings[:per_batch]
      touch(table, repo, min_id, max_id)

      # Run vacuum if the number of dirty records exceeds our tolerance
      if dirty >= settings[:vacuum] do
        vacuum(table, repo)
        0
      else
        dirty + settings[:per_batch]
      end
    end)
  end

  defp process(_) do
    Logger.error("Missing one or more args. --table and --repo are required.")
  end

  defp touch(table, repo, min_id, max_id) do
    Ecto.Adapters.SQL.query!(
      repo,
      "UPDATE #{table} SET id=id WHERE id > $1 AND id <= $2;",
      [min_id, max_id]
    )
  end

  defp get_repo(string_repo_name), do: String.to_existing_atom("Elixir." <> string_repo_name)

  defp get_settings(table, repo) do
    total = count(table, repo)
    per_batch = batch_size(total)

    %{
      table: table,
      count: total,
      per_batch: per_batch,
      num_batches: trunc(Float.ceil(total / per_batch)),
      vacuum: vacuum_size(total)
    }
  end

  defp count(table, repo) do
    repo.one(from p in table, select: count(p.id))
  end

  defp batch_size(total) do
    case total do
      x when x < 200_000 -> 10_000
      x when x >= 200_000 and x < 1_000_000 -> 100_000
      x when x >= 1_000_000 -> 1_000_000
    end
  end

  # Since we're guests in someone else's house, we want to make sure and clean up after ourselves.
  #
  # If we vacuum often, it will minimize table bloat since every updated row is rewritten to the bottom of the data file. 
  # Normally, PG will run a vacuum when 20% of the table's records have been changed. 
  # Since we're touching an entire table, the auto vacuum won't be able to keep up. Because of this, we'll want to 
  # run it ourselves and let it finish before resuming additional updates. 
  #
  # We should run a checkpoint before running vacuum to make sure all of the data is present in the datafile before cleaning it up.

  defp vacuum(table, repo) do
    if Application.get_env(:sistine, :env) != :test do
      checkpoint(repo)

      Logger.info("VACUUM #{table}")

      Ecto.Adapters.SQL.query!(
        repo,
        "VACUUM #{table};"
      )
    end
  end

  defp vacuum_size(total) do
    case trunc(total * @vacuum_percentage) do
      x when x < 20_000 -> 20_000
      x when x >= 20_000 -> x
    end
  end

  # Checkpoints write data saved to the WAL to the data files. 
  # We want to do this before running a vacuum to ensure that it's cleaning up everything it's supposed to.

  defp checkpoint(repo) do
    if Application.get_env(:sistine, :env) != :test do
      Logger.info("CHECKPOINT")

      Ecto.Adapters.SQL.query!(
        repo,
        "CHECKPOINT;"
      )
    end
  end
end
