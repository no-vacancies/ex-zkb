import Config

config :ex_zkb, ExZkb.Pathfinder.Repo,
  database: "pathfinder",
  username: "pathfinder",
  password: "pathfinder",
  hostname: "localhost",
  pool_size: Ecto.Adapters.SQL.Sandbox

config :logger, level: :warn
