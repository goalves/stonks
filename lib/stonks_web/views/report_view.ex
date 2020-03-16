defmodule StonksWeb.ReportView do
  use StonksWeb, :view
  alias StonksWeb.ReportView

  @spec render(binary(), map()) :: map()
  def render("show.json", %{report: report}), do: %{data: render_one(report, ReportView, "report.json")}

  def render("report.json", %{report: report}) do
    %{
      id: report.id,
      start_datetime: report.start_datetime,
      end_datetime: report.end_datetime,
      total: report.total
    }
  end
end
