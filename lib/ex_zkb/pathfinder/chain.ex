defmodule ExZkb.Pathfinder.Chain do
  @moduledoc """
  Functions for building the home chain from data in the Pathfinder database
  """
  import Ecto.Query
  require Logger

  alias ExZkb.Pathfinder.{Connection, Repo, System}

  defstruct [
    :map_id,
    :root,
    :chain,
    :connected,
    :updated
  ]

  def find_connections(map_id) do
    query =
      from(c in Connection,
        join: src in System,
        on: [id: c.source],
        join: dst in System,
        on: [id: c.target],
        where: c.mapId == ^map_id,
        select: {src.systemId, dst.systemId}
      )

    Repo.all(query)
  end

  def bidirectional(connections) do
    connections
    |> Enum.reduce(connections, fn {a, b}, acc -> [{b, a} | acc] end)
  end

  def build_chain(map_id) do
    all_connections =
      map_id
      |> find_connections()
      |> bidirectional()

    system_labels(map_id)
    |> Enum.reduce(create_graph(), &add_system_to_graph/2)
    |> Graph.add_edges(all_connections)
  end

  def connected_systems(chain, system) when is_integer(system) do
    connected_systems(chain, [system])
  end

  def connected_systems(chain, systems) when is_list(systems) do
    Graph.reachable(chain, systems)
  end

  def init_chain(map_id, root) do
    chain = build_chain(map_id)

    %__MODULE__{
      map_id: map_id,
      root: root,
      chain: chain,
      connected: connected_systems(chain, root),
      updated: DateTime.utc_now()
    }
  end

  def route(%__MODULE__{} = chain, system_id) do
    Graph.dijkstra(chain.chain, chain.root, system_id)
    |> Enum.map(&label_for_system(chain, &1))
  end

  def print_chain(chain) do
    {:ok, dot} = Graph.Serializers.DOT.serialize(chain)
    IO.puts(dot)
  end

  def label_for_system(%__MODULE__{chain: g}, system_id) do
    Graph.vertex_labels(g, system_id)
    |> hd
  end

  defp create_graph() do
    Graph.new()
  end

  defp add_system_to_graph({system_id, label}, graph) do
    Graph.add_vertex(graph, system_id, label)
  end

  def system_labels(map_id) do
    target_query =
      from(c in Connection,
        join: dst in System,
        on: [id: c.target],
        where: c.mapId == ^map_id,
        select: {dst.systemId, dst.alias}
      )

    query =
      from(c in Connection,
        join: src in System,
        on: [id: c.source],
        where: c.mapId == ^map_id,
        select: {src.systemId, src.alias},
        union: ^target_query
      )

    Repo.all(query)
  end
end
