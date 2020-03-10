Bureaucrat.start(
  writer: Bureaucrat.ApiBlueprintWriter,
  default_path: "docs/documentation.md",
  paths: [],
  titles: [],
  title: "Stonks Bank API",
  env_var: "API_DOCS",
  json_library: Jason
)

ExUnit.start(formatters: [ExUnit.CLIFormatter, Bureaucrat.Formatter])
Faker.start()
{:ok, _} = Application.ensure_all_started(:ex_machina)
Ecto.Adapters.SQL.Sandbox.mode(Stonks.Repo, :manual)
