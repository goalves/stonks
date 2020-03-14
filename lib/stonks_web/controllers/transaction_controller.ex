defmodule StonksWeb.TransactionController do
  use StonksWeb, :controller

  alias Ecto.Changeset
  alias Guardian.Plug, as: GuardianPlug
  alias Plug.Conn
  alias Stonks.Business
  alias Stonks.Business.Transaction

  action_fallback StonksWeb.FallbackController

  @spec create(Conn.t(), map()) :: Conn.t() | {:error, Changeset.t()}
  def create(conn = %Conn{}, %{"transaction" => transaction_params}) do
    origin_user_id = GuardianPlug.current_resource(conn)
    updated_params = Map.put(transaction_params, "origin_user_id", origin_user_id)

    with {:ok, transaction = %Transaction{}} <- Business.create_transaction(updated_params) do
      conn
      |> put_status(:created)
      |> render("show.json", transaction: transaction)
    end
  end

  def create(%Conn{}, _), do: {:error, :bad_request}
end
