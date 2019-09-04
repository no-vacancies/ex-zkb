defmodule ExZkb.Handler do
  @moduledoc """
  Handler functions for further processing parsed messages from the zkb webhook
  """
  require Logger
  alias ExZkb.Pathfinder, as: PF
  alias ExZkb.Kill

  @affiliated %{
    "alliance_id" => [99_009_324, 99_006_113],
    "corporation_id" => [],
    "character_id" => []
  }

  def handle(%Kill{} = kill) do
    kill
    |> check_chain()
    |> check_affiliated(@affiliated)
    |> process()
  end

  def handle(parsed) do
    Logger.debug(~s(Handling unknown message #{inspect(parsed)}))
    :ok
  end

  defp check_chain(%Kill{system_id: system_id} = kill) do
    case PF.in_chain?(system_id) do
      true ->
        Logger.debug("Kill #{kill.kill_id} is in chain")

        %{
          kill
          | in_chain: true,
            route: PF.route(system_id)
        }

      false ->
        Logger.debug("Kill #{kill.kill_id} not in chain")
        kill
    end
  end

  defp check_affiliated(kill, affiliations) do
    in_corp = Kill.affiliated?(kill, affiliations)
    %{kill | in_corp: in_corp}
  end

  def process(%Kill{in_corp: false, in_chain: true} = kill) do
    Logger.debug("Posting to #chain-kills...")
    kill
    |> ExZkb.Discord.send()
  end

  def process(%Kill{in_corp: true} = kill) do
    Logger.debug("Posting to #killbot (to be implemented)")
    kill
  end

  def process(%Kill{} = kill) do
    Logger.debug("Skipping...")
    kill
  end
end
