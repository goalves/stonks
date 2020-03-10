defmodule StonksWeb.ErrorViewTest do
  use StonksWeb.ConnCase, async: true

  alias StonksWeb.ErrorView

  import Phoenix.View

  test "renders 400.json" do
    assert render(ErrorView, "400.json", []) == %{errors: %{detail: "Bad Request"}}
  end

  test "renders 404.json" do
    assert render(ErrorView, "404.json", []) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500.json" do
    assert render(ErrorView, "500.json", []) == %{errors: %{detail: "Internal Server Error"}}
  end
end
