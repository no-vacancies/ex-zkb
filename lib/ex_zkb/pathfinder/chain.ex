defmodule ExZkb.Pathfinder.Chain do
  @moduledoc """
  Functions for building the home chain from data in the Pathfinder database
  """
  import Ecto.Query

  alias ExZkb.PFRepo
  alias ExZkb.Pathfinder.{Connection, System}

  def find_connections(map_id) do
    _ = """
    SELECT src.alias, src.systemId, src.id, dst.alias, dst.systemId, dst.id FROM connection c
    INNER JOIN system src ON src.id = c.source
    INNER JOIN system dst ON dst.id = c.target
    WHERE c.mapId = 2;
    """
    query = from c in Connection,
              join: src in System,
              on: [id: c.source],
              join: dst in System,
              on: [id: c.target],
              where: c.mapId == ^map_id,
              select: {src.systemId, dst.systemId}

    PFRepo.all(query)
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

  def print_chain(chain) do
    {:ok, dot} = Graph.Serializers.DOT.serialize(chain)
    IO.puts(dot)
  end

  defp create_graph() do
    Graph.new()
  end

  defp add_system_to_graph({system_id, label}, graph) do
    Graph.add_vertex(graph, system_id, label)
  end

  def system_labels(map_id) do
    PFRepo.query("""
    SELECT src.alias, src.systemId
    FROM connection c
    INNER JOIN system src on src.id = c.source
    WHERE c.mapId = $1
    UNION
    SELECT dst.alias, dst.systemId
    FROM connection c
    INNER JOIN system dst on dst.id = c.target
    WHERE c.mapId = $1
    """, [map_id])

    target_query = from c in Connection,
                   join: dst in System,
                   on: [id: c.target],
                   where: c.mapId == ^map_id,
                   select: {dst.systemId, dst.alias}

    query = from c in Connection,
            join: src in System,
            on: [id: c.source],
            where: c.mapId == ^map_id,
            select: {src.systemId, src.alias},
            union: ^target_query

    PFRepo.all(query)
  end
end
