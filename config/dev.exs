import Config

config :logger, level: :debug

config :ex_zkb, ExZkb.Pathfinder.Repo,
  database: "pathfinder",
  username: "pathfinder",
  password: "pathfinder",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :ex_zkb, ExZkb.Discord,
  webhook_url: "https://discordapp.com/api/webhooks/{webhook.id}/{webhook.token}"
