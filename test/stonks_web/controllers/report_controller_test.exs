defmodule StonksWeb.ReportControllerTest do
  use StonksWeb.ConnCase

  import Stonks.Factory

  alias Stonks.Accounts.Guardian

  setup %{conn: conn},
    do: {:ok, conn: put_req_header(conn, "accept", "application/json")}

  describe "POST /reports" do
    setup %{conn: conn} do
      operator = insert(:operator)
      {:ok, token, _claims} = Guardian.encode_and_sign(operator, %{}, token_type: "operator_access")
      conn = put_req_header(conn, "authorization", "Bearer: #{token}")

      %{conn: conn, operator: operator}
    end

    test "renders a report when data is valid", %{conn: conn} do
      now = DateTime.utc_now() |> DateTime.truncate(:second)
      transaction = insert(:withdraw_transaction, datetime: now)

      params = params_for(:report_filter, start_datetime: now, end_datetime: now)

      response =
        conn
        |> post(Routes.operator_reports_path(conn, :create), report: params)
        |> doc(description: "Create Report", operation_id: "create_report")
        |> json_response(201)

      assert response["data"]["total"] == transaction.amount
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        conn
        |> post(Routes.operator_reports_path(conn, :create), report: %{})
        |> doc(
          description: "Create Report when report parameters are invalid",
          operation_id: "create_report_failed"
        )

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders bad request when parameters does not contain report key", %{conn: conn} do
      assert conn
             |> post(Routes.operator_reports_path(conn, :create), %{})
             |> doc(
               description: "Create Report when parameters are invalid",
               operation_id: "create_report_bad_request"
             )
             |> json_response(400) == %{"errors" => %{"detail" => "Bad Request"}}
    end

    test "should not allow unauthorized users to ask for reports", %{conn: conn} do
      user = insert(:user)
      {:ok, token, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "user_access")

      assert conn
             |> put_req_header("authorization", "Bearer: #{token}")
             |> post(Routes.operator_reports_path(conn, :create), %{})
             |> plug_doc(module: __MODULE__, action: :create)
             |> doc(description: "Create Report Unauthorized", operation_id: "create_report_unauthorized")
             |> json_response(401) == %{"errors" => %{"detail" => "Unauthorized"}}
    end
  end
end
