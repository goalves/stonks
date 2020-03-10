defmodule Stonks.DataCase do
  use ExUnit.CaseTemplate
  alias Ecto.Adapters.SQL.Sandbox
  alias Ecto.Changeset
  alias Stonks.Repo

  using do
    quote do
      alias Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Stonks.DataCase
    end
  end

  setup tags do
    :ok = Sandbox.checkout(Repo)

    unless tags[:async] do
      Sandbox.mode(Repo, {:shared, self()})
    end

    :ok
  end

  def errors_on(changeset = %Changeset{}) do
    Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
