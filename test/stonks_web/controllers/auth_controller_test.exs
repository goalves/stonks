defmodule StonksWeb.AuthControllerTest do
  use StonksWeb.ConnCase

  import Stonks.Factory

  alias Ecto.UUID
  alias Stonks.Accounts.Guardian

  setup %{conn: conn},
    do: {:ok, conn: put_req_header(conn, "accept", "application/json")}

  describe "POST /auth" do
    test "renders the user token when parameters are valid", %{conn: conn} do
      password = UUID.generate()
      password_hash = Argon2.hash_pwd_salt(password)
      user = insert(:user, password_hash: password_hash)

      params = %{email: user.email, password: password}

      assert %{"token" => token} =
               conn
               |> post(Routes.auth_path(conn, :sign_in), auth: params)
               |> doc(description: "Authorize User", operation_id: "authorize_user")
               |> json_response(201)

      assert {:ok, %{"aud" => "stonks", "sub" => sub}} = Guardian.decode_and_verify(token)
      assert sub == user.id
    end

    test "renders an error when password is invalid", %{conn: conn} do
      password = UUID.generate()
      invalid_password = UUID.generate()
      password_hash = Argon2.hash_pwd_salt(password)
      user = insert(:user, password_hash: password_hash)

      params = %{email: user.email, password: invalid_password}

      assert conn
             |> post(Routes.auth_path(conn, :sign_in), auth: params)
             |> doc(description: "Authorize user with wrong password", operation_id: "authorize_user_failed")
             |> json_response(401) == %{"errors" => %{"detail" => "Unauthorized"}}
    end

    test "renders bad request when parameters does not contain auth key", %{conn: conn} do
      conn =
        conn
        |> post(Routes.auth_path(conn, :sign_in), %{})
        |> doc(
          description: "Authorize user with wrong parameters",
          operation_id: "authorize_user_bad_request"
        )

      assert json_response(conn, 400) == %{"errors" => %{"detail" => "Bad Request"}}
    end
  end
end
