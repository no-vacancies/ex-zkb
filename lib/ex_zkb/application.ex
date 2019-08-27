defmodule ExZkb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: ExZkb.Worker.start_link(arg)
      {ExZkb.Client, :ok},
      ExZkb.PFRepo
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExZkb.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
