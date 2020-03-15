defmodule StonksWeb.UserControllerTest do
  use StonksWeb.ConnCase

  import Stonks.Factory

  alias Faker.Internet
  alias Stonks.Accounts.{Guardian, User}
  alias Stonks.Repo

  setup %{conn: conn},
    do: {:ok, conn: put_req_header(conn, "accept", "application/json")}

  describe "POST /users" do
    test "renders user when data is valid", %{conn: conn} do
      email = Internet.email()
      params = params_for(:user, email: email)

      response =
        conn
        |> post(Routes.user_path(conn, :create), user: params)
        |> doc(description: "Create User", operation_id: "create_user")
        |> json_response(201)

      assert %User{} = Repo.get(User, response["data"]["id"])
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        conn
        |> post(Routes.user_path(conn, :create), user: %{})
        |> doc(
          description: "Create User when user parameters are invalid",
          operation_id: "create_user_failed"
        )

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders bad request when parameters does not contain user key", %{conn: conn} do
      conn =
        conn
        |> post(Routes.user_path(conn, :create), %{})
        |> doc(
          description: "Create User when parameters are invalid",
          operation_id: "create_user_bad_request"
        )

      assert json_response(conn, 400) == %{"errors" => %{"detail" => "Bad Request"}}
    end
  end

  describe "GET /users/me" do
    setup %{conn: conn} do
      user = insert(:user)
      {:ok, token, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "user_access")
      conn = put_req_header(conn, "authorization", "Bearer: #{token}")

      %{conn: conn, user: user}
    end

    test "renders the user with the current authorization token", %{conn: conn, user: user} do
      response =
        conn
        |> get(Routes.user_path(conn, :show_me))
        |> doc(description: "Show Current User", operation_id: "show_current_user")
        |> json_response(200)

      assert response["data"]["id"] == user.id
    end

    test "renders an error if the token is invalid", %{conn: conn} do
      conn = put_req_header(conn, "authorization", "Bearer: #{}")

      assert conn
             |> get(Routes.user_path(conn, :show_me))
             |> doc(
               description: "Show Current User using Invalid Token",
               operation_id: "show_current_user_with_invalid_token"
             )
             |> json_response(401) == %{"errors" => %{"detail" => "Unauthorized"}}
    end

    test "renders an error if the user does not exist", %{conn: conn} do
      {:ok, token, _} = :user |> build() |> Guardian.encode_and_sign([], token_type: "user_access")
      conn = put_req_header(conn, "authorization", "Bearer: #{token}")

      assert conn
             |> get(Routes.user_path(conn, :show_me))
             |> doc(description: "Show Current User when User does not Exist", operation_id: "show_current_user")
             |> json_response(401) == %{"errors" => %{"detail" => "Unauthorized"}}
    end
  end
end
