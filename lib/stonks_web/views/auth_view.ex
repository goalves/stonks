defmodule StonksWeb.AuthView do
  use StonksWeb, :view

  @spec render(binary(), map()) :: map()
  def render("token.json", %{token: token}), do: %{token: token}
end
