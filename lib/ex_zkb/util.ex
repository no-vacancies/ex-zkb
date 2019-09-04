defmodule ExZkb.Util do
  def prune(%{__struct__: _} = struct) do
    struct
    |> Map.from_struct()
    |> prune()
  end

  def prune(%{} = map) do
    map
    |> Enum.reject(fn {_, v} -> v == nil end)
    |> Enum.into(%{})
  end
end
