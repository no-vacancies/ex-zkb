defmodule ExZkb.Pathfinder do
  @moduledoc """
  Public API for Pathfinder-related functions
  """
  alias ExZkb.Pathfinder.Worker

  @doc """
  Determine if a system_id is reachable from the selected root system

  ## Examples

      iex> ExZkb.Pathfinder.in_chain?(30000970)
      false
  """
  @spec in_chain?(integer()) :: boolean()
  def in_chain?(system_id) do
    Worker.in_chain?(system_id)
  end
end
