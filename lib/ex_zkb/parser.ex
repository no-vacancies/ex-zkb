defmodule ExZkb.Parser do
  @moduledoc """
  Parser functions to parse messages received from the webhook
  """
  require Logger

  def parse(%{"killmail_id" => _killid} = kill) do
    Logger.debug(~s(Kill in #{kill["solar_system_id"]}: #{kill["zkb"]["url"]}))

    kill
    |> ExZkb.Kill.from_zkb()
  end

  def parse(msg) do
    Logger.debug("Unhandled message #{inspect(msg)}")
    msg
  end
end
