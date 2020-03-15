defmodule StonksWeb.Guardian.OperatorAuthPipeline do
  alias Guardian.Plug.{EnsureAuthenticated, LoadResource, Pipeline, VerifyHeader}
  alias Stonks.Accounts.Guardian
  alias StonksWeb.Guardian.AuthErrorHandler

  use Pipeline,
    otp_app: :stonks,
    module: Guardian,
    error_handler: AuthErrorHandler

  plug VerifyHeader, claims: %{"typ" => "operator_access"}
  plug EnsureAuthenticated
  plug LoadResource, allow_blank: false
end
