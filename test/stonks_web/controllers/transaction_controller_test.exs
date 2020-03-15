defmodule StonksWeb.TransactionControllerTest do
  use StonksWeb.ConnCase

  import Stonks.Factory

  alias Stonks.Accounts.{Guardian}
  alias Stonks.Business.Transaction
  alias Stonks.Repo

  setup %{conn: conn},
    do: {:ok, conn: put_req_header(conn, "accept", "application/json")}

  describe "POST /users/me/transactions" do
    setup %{conn: conn} do
      user = insert(:user)
      {:ok, token, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "user_access")
      conn = put_req_header(conn, "authorization", "Bearer: #{token}")

      %{conn: conn, user: user}
    end

    test "renders transaction when data is valid", %{conn: conn, user: user} do
      params = :withdraw_transaction |> params_for(amount: user.balance) |> Map.delete([:origin_user_id])

      response =
        conn
        |> post(Routes.users_me_transactions_path(conn, :create), transaction: params)
        |> doc(description: "Create Transaction", operation_id: "create_transaction")
        |> json_response(201)

      assert %Transaction{} = Repo.get(Transaction, response["data"]["id"])
    end

    test "does not allow users to impersonate other users when creating transactions", %{conn: conn, user: user} do
      amount = 5_000_000
      other_user = insert(:user, balance: amount)
      params = :withdraw_transaction |> params_for(amount: amount) |> Map.put(:origin_user_id, other_user.id)

      response =
        conn
        |> post(Routes.users_me_transactions_path(conn, :create), transaction: params)
        |> doc(
          description: "Create Transaction when trying to impersonate other users",
          operation_id: "create_transaction_impersonating_failed"
        )
        |> json_response(201)

      assert transaction = Repo.get(Transaction, response["data"]["id"])
      assert transaction.origin_user_id == user.id
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        conn
        |> post(Routes.users_me_transactions_path(conn, :create), transaction: %{})
        |> doc(
          description: "Create Transaction when transaction parameters are invalid",
          operation_id: "create_transaction_failed"
        )

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders bad request when parameters does not contain transaction key", %{conn: conn} do
      conn =
        conn
        |> post(Routes.users_me_transactions_path(conn, :create), %{})
        |> doc(
          description: "Create Transaction when parameters are invalid",
          operation_id: "create_transaction_bad_request"
        )

      assert json_response(conn, 400) == %{"errors" => %{"detail" => "Bad Request"}}
    end
  end
end
