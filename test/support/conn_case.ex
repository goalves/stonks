defmodule StonksWeb.ConnCase do
  use ExUnit.CaseTemplate
  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      use Phoenix.ConnTest

      import Bureaucrat.Helpers

      alias StonksWeb.Router.Helpers, as: Routes

      @endpoint StonksWeb.Endpoint
    end
  end

  setup tags do
    :ok = Sandbox.checkout(Stonks.Repo)

    unless tags[:async] do
      Sandbox.mode(Stonks.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
