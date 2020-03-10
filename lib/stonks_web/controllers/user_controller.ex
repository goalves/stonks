defmodule StonksWeb.UserController do
  use StonksWeb, :controller

  alias Ecto.Changeset
  alias Guardian.Plug, as: GuardianPlug
  alias Plug.Conn
  alias Stonks.{Accounts, Validator}
  alias Stonks.Accounts.User

  action_fallback StonksWeb.FallbackController

  @spec create(Conn.t(), map()) :: Conn.t() | {:error, Changeset.t()}
  def create(conn = %Conn{}, %{"user" => user_params}) do
    with {:ok, user = %User{}} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end

  def create(%Conn{}, _), do: {:error, :bad_request}

  @spec show(Conn.t(), map()) :: Conn.t() | {:error, :user_does_not_exist}
  def show(conn = %Conn{}, %{"id" => id}) do
    with :ok <- Validator.validate_uuid(id),
         {:ok, user = %User{}} <- Accounts.get_user(id) do
      conn
      |> put_status(:ok)
      |> render("show.json", user: user)
    end
  end

  @spec show_me(Conn.t(), map()) :: Conn.t() | {:error, :user_does_not_exist}
  def show_me(conn = %Conn{}, _) do
    user_id = GuardianPlug.current_resource(conn)
    show(conn, %{"id" => user_id})
  end
end
