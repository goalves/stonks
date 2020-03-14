defmodule Stonks.Mailer do
  require Logger

  @spec deliver(binary) :: {:ok, binary()} | {:error, :invalid_email}
  def deliver(text) when is_binary(text) do
    Logger.info("Email sent 📧")
    {:ok, text}
  end

  def deliver(_), do: {:error, :invalid_email}
end
