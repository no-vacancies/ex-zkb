defmodule ExZkb.Pathfinder.Worker do
  use GenServer
  require Logger
  alias ExZkb.Pathfinder.Chain

  @map_id 2
  @home_chain_root 31_002_217
  # seconds, only triggered on websocket frame received
  @map_refresh_interval 60

  # Client interface

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def in_chain?(system_id) do
    GenServer.call(__MODULE__, {:check_in_chain, system_id})
  end


  # Server Callbacks

  def handle_call({:check_in_chain, system_id}, _, state) do
    state = maybe_update(state)
    reply = system_id in state.connected
    {:reply, reply, state}
  end

  def init(initial_state) do
    {:ok, initial_state, {:continue, :init_map}}
  end

  def handle_continue(:init_map, _state) do
    state = Chain.init_chain(@map_id, @home_chain_root)
    {:noreply, state}
  end

  defp maybe_update(%{updated: updated} = chain) do
    if DateTime.diff(DateTime.utc_now(), updated) > @map_refresh_interval do
      Logger.info("Updating chain for map #{chain.map_id}, root system #{chain.root}")
      Chain.init_chain(chain.map_id, chain.root)
    else
      chain
    end
  end
end
