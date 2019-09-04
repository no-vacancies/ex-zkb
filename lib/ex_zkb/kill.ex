defmodule ExZkb.Kill do
  @enforce_keys [:kill_id, :system_id, :killmail]
  defstruct kill_id: nil,
            route: nil,
            system_id: nil,
            url: nil,
            in_corp: false,
            in_chain: false,
            killmail: %{},
            meta: %{}

  def from_zkb(%{} = zkb) do
    %__MODULE__{
      kill_id: zkb["killmail_id"],
      system_id: zkb["solar_system_id"],
      url: zkb["zkb"]["url"],
      killmail: zkb
    }
  end

  def affiliated?(%__MODULE__{} = kill, affiliations) do
    affiliated?(kill.killmail["victim"], affiliations) ||
      Enum.any?(kill.killmail["attackers"], &affiliated?(&1, affiliations))
  end

  def affiliated?(subject, affiliations) do
    subject["alliance_id"] in affiliations["alliance_id"] ||
      subject["corporation_id"] in affiliations["corporation_id"] ||
      subject["character_id"] in affiliations["character_id"]
  end
end
