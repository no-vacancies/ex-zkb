defmodule ExZkb.Pathfinder.System do
  use Ecto.Schema

  schema "system" do
    field(:created, :utc_datetime)
    field(:updated, :utc_datetime)
    field(:active, :boolean)
    field(:mapId, :integer)
    field(:systemId, :integer)
    field(:alias, :string)
    field(:typeId, :integer)
    field(:description, :string)

    has_many(:outgoing, ExZkb.Pathfinder.Connection, foreign_key: :source)
    has_many(:incoming, ExZkb.Pathfinder.Connection, foreign_key: :target)
  end
end
