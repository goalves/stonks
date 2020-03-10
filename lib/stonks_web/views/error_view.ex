defmodule StonksWeb.ErrorView do
  use StonksWeb, :view

  @spec render(binary(), any()) :: %{errors: %{detail: binary()}}
  def render("400.json", _), do: %{errors: %{detail: "Bad Request"}}

  def render("401.json", _), do: %{errors: %{detail: "Unauthorized"}}

  def render("404.json", _), do: %{errors: %{detail: "Not Found"}}

  def render("500.json", _), do: %{errors: %{detail: "Internal Server Error"}}
end
