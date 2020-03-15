defmodule StonksWeb.AuthController do
  use StonksWeb, :controller

  alias Plug.Conn
  alias Stonks.Auth

  action_fallback StonksWeb.FallbackController

  @spec sign_in(Conn.t(), any()) :: Conn.t() | {:error, :bad_request}
  def sign_in(conn = %Conn{}, %{"auth" => %{"email" => email, "password" => password}}) do
    with {:ok, token, _} when is_binary(token) <- Auth.authenticate(email, password) do
      conn
      |> put_status(:created)
      |> render("token.json", token: token)
    end
  end

  def sign_in(%Conn{}, _), do: {:error, :bad_request}
end
