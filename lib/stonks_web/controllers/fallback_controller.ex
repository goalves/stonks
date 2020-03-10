defmodule StonksWeb.FallbackController do
  use StonksWeb, :controller

  require Logger

  alias Ecto.Changeset
  alias Elixir.Plug.Conn
  alias StonksWeb.{ChangesetView, ErrorView}

  @not_found_resources [:user_does_not_exist]

  @spec call(Conn.t(), any()) :: Conn.t()
  def call(conn = %Conn{}, {:error, %Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn = %Conn{}, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(ErrorView)
    |> render("404.json")
  end

  def call(conn = %Conn{}, {:error, :bad_request}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> render("400.json")
  end

  def call(conn = %Conn{}, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ErrorView)
    |> render("401.json")
  end

  def call(conn = %Conn{}, {:error, :invalid_uuid}), do: call(conn, {:error, :bad_request})

  def call(conn = %Conn{}, {:error, reason}) when reason in @not_found_resources,
    do: call(conn, {:error, :not_found})

  def call(conn = %Conn{}, error) do
    %{private: %{phoenix_controller: controller, phoenix_action: action}, body_params: body_params} = conn

    Logger.error(
      "Route was called and did not match anything in controller or fallback. Controller:#{inspect(controller)}. Method: #{
        inspect(action)
      }. Parameters: #{inspect(body_params)} The error that was sent was: #{inspect(error)}."
    )

    conn
    |> put_status(:internal_server_error)
    |> put_view(ErrorView)
    |> render("500.json")
  end
end
