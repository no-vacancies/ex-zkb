defmodule ExZkb.Handler do
  @moduledoc """
  Handler functions for further processing parsed messages from the zkb webhook
  """
  require Logger
  alias ExZkb.Pathfinder, as: PF

  def handle(%{"solar_system_id" => system_id, "killmail_id" => kill_id} = _parsed) do
    case PF.in_chain?(system_id) do
      true -> Logger.debug(" ### KILL #{kill_id} IN CHAIN ### ")
      _ -> Logger.debug("Kill #{kill_id} not in chain")
    end
    :ok
  end

  def handle(parsed) do
    Logger.debug(~s(Handling unknown message #{inspect parsed}))
    :ok
  end
end
