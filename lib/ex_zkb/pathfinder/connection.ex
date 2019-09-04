defmodule ExZkb.Pathfinder.Connection do
  use Ecto.Schema

  schema "connection" do
    field(:created, :utc_datetime)
    field(:updated, :utc_datetime)
    field(:active, :boolean)
    field(:mapId, :integer)
    # field :source, :integer
    # field :target, :integer
    field(:scope, :string)
    field(:type, :string)

    belongs_to(:source_system, ExZkb.Pathfinder.System, foreign_key: :source)
    belongs_to(:target_system, ExZkb.Pathfinder.System, foreign_key: :target)
  end
end
