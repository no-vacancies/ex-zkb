defmodule ExZkb.PFRepo do
  use Ecto.Repo,
    otp_app: :ex_zkb,
    adapter: Ecto.Adapters.MyXQL
end
