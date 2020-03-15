defmodule StonksWeb do
  alias Plug.Conn

  def controller do
    quote do
      use Phoenix.Controller, namespace: StonksWeb

      import Conn
      alias StonksWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/stonks_web/templates",
        namespace: StonksWeb

      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      alias StonksWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Phoenix.Controller
      import Conn
    end
  end

  defmacro __using__(which) when is_atom(which),
    do: apply(__MODULE__, which, [])
end
