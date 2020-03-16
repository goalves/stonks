defmodule StonksWeb.ReportController do
  use StonksWeb, :controller

  alias Ecto.Changeset
  alias Plug.Conn
  alias Stonks.Backoffice
  alias Stonks.Backoffice.Report

  action_fallback StonksWeb.FallbackController

  @spec create(Conn.t(), map()) :: Conn.t() | {:error, Changeset.t()}
  def create(conn = %Conn{}, %{"report" => report_params}) do
    with {:ok, report = %Report{}} <- Backoffice.create_report(report_params) do
      conn
      |> put_status(:created)
      |> render("show.json", report: report)
    end
  end

  def create(%Conn{}, _), do: {:error, :bad_request}
end
