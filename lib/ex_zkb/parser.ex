defmodule ExZkb.Parser do
  @moduledoc """
  Parser functions to parse messages received from the webhook
  """
  require Logger

  def parse(%{"solar_system_id" => system_id} = kill) do
    Logger.info(~s(Kill in #{system_id}: #{kill["zkb"]["url"]}))
    kill
  end

  def parse(msg) do
    Logger.info("Unhandled message #{inspect msg}")
    :ok
  end
end
