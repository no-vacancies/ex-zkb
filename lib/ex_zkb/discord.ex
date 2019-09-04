defmodule ExZkb.Discord do
  @moduledoc """
  Discord functions
  """
  alias ExZkb.Discord.Message
  alias ExZkb.Kill

  @webhook_url Application.get_env(:ex_zkb, ExZkb.Discord)[:webhook_url]

  def format(%Kill{in_chain: true} = kill) do
    system = List.last(kill.route)
    route = Enum.join(kill.route, " -> ")
    distance = length(kill.route) - 1

    """
    Kill in **#{system}**
    Distance: #{distance} Jumps, #{route}
    #{kill.url}
    """
  end

  def send(%Kill{in_chain: true} = kill, opts \\ []) do
    kill
    |> format()
    |> Message.text(opts)
    |> dispatch()
  end

  def dispatch(%Message{} = message) do
    message = Jason.encode!(message)
    headers = [{"Content-Type", "application/json"}]
    HTTPoison.post!(@webhook_url, message, headers)
  end
end
