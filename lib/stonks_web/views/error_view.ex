defmodule StonksWeb.ErrorView do
  use StonksWeb, :view

  def render("400.json", _), do: %{errors: %{detail: "Bad Request"}}

  def render("404.json", _), do: %{errors: %{detail: "Not Found"}}

  def render("500.json", _), do: %{errors: %{detail: "Internal Server Error"}}
end
