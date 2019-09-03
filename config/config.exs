import Config

config :logger,
  level: :warn,
  truncate: 4096

config :ex_zkb,
  ecto_repos: [ExZkb.Pathfinder.Repo]

import_config "#{Mix.env()}.exs"
