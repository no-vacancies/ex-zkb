import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

webhook_url =
  System.get_env("WEBHOOK_URL") ||
    raise """
    environment variable WEBHOOK_URL is missing.
    For example: https://discordapp.com/api/webhooks/{webhook.id}/{webhook.token}
    """

config :ex_zkb, ExZkb.Pathfinder.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :ex_zkb, ExZkb.Discord,
  webhook_url: webhook_url
