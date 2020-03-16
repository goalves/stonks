defmodule Stonks.Backoffice.ReportFilterTest do
  use Stonks.DataCase, async: true

  import Stonks.Factory

  alias Ecto.Changeset
  alias Stonks.Backoffice.ReportFilter

  describe "new/1" do
    test "returns a tuple with a valid structure when parameters are valid" do
      attributes = params_for(:report_filter)
      assert {:ok, report = %ReportFilter{}} = ReportFilter.new(attributes)
      assert report.start_datetime == attributes.start_datetime
      assert report.end_datetime == attributes.end_datetime
    end

    test "returns a tuple with an invalid changeset when parameters are missing" do
      assert {:error, changeset = %Changeset{valid?: false}} = ReportFilter.new(%{})

      assert errors_on(changeset) == %{
               start_datetime: ["can't be blank"]
             }
    end
  end
end
