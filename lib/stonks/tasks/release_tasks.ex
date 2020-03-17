defmodule Stonks.Tasks.ReleaseTasks do
  @start_apps [
    :ssl,
    :postgrex,
    :ecto,
    :ecto_sql
  ]
  @logger_module :logger
  @otp_app :stonks

  @seeds_file "seeds.exs"

  alias Ecto.Migrator
  alias Stonks.Repo

  require Logger

  @spec setup(any()) :: :ok
  def setup(_opts \\ []) do
    start(:logger)

    Logger.info("#> Booting Application")
    start(:app)

    Logger.info("#> Starting Application Dependencies")
    start(:app_dependencies)

    Logger.info("#> Starting Database Connection")
    start(:database_connection)

    Logger.info("#> Running Migrations")
    run_migrations()

    Logger.info("#> Running Seeds")
    run_seed(@seeds_file)

    Logger.info("#> Finished release tasks, application will start soon... Time for a ☕️")
  end

  defp start(:logger), do: Application.ensure_started(@logger_module)

  defp start(:database_connection), do: {:ok, _} = Repo.start_link(pool_size: 10)

  defp start(:app), do: Application.load(@otp_app)

  defp start(:app_dependencies) do
    Enum.each(@start_apps, fn app ->
      result = Application.ensure_all_started(app)
      Logger.info("#> Starting: #{app} - #{inspect(result)}")
    end)
  end

  defp run_migrations,
    do: Migrator.run(Repo, Migrator.migrations_path(Repo), :up, all: true, log: :debug)

  def run_seed(filename) do
    Logger.info("#> Running Seed for #{filename}")
    seed_file = priv_path_for(filename)

    if File.exists?(seed_file),
      do: run_seed_file(seed_file),
      else: Logger.error("#> ERROR: Seed file #{filename} not found")
  end

  defp run_seed_file(seed_file) do
    Code.eval_file(seed_file)
    Logger.info("#> Ok")
  end

  @spec priv_path_for(binary()) :: binary()
  defp priv_path_for(filename) when is_binary(filename) do
    app = Keyword.get(Repo.config(), :otp_app)

    repo_underscore =
      Repo
      |> Module.split()
      |> List.last()
      |> Macro.underscore()

    Path.join(["#{:code.priv_dir(app)}", repo_underscore, filename])
  end
end
