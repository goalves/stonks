defmodule StonksWeb.Guardian.AuthErrorHandler do
  use StonksWeb, :controller

  alias Plug.Conn
  alias StonksWeb.ErrorView

  @spec auth_error(Conn.t(), any(), any()) :: Conn.t()
  def auth_error(conn = %Conn{}, _, _) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ErrorView)
    |> render("401.json")
  end
end
