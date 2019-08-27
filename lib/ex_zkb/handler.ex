defmodule ExZkb.Handler do
  @moduledoc """
  Handler functions for further processing parsed messages from the zkb webhook
  """
  require Logger

  def handle(%{"killmail_id" => _} = parsed) do
    Logger.info(~s(Handling kill #{parsed["killmail_id"]}))
    :ok
  end

  def handle(parsed) do
    Logger.info(~s(Handling unknown message #{inspect parsed}))
  end
end
