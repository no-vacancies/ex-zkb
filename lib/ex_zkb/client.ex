defmodule ExZkb.Client do
  @moduledoc """
  Websocket Client for zkillboard

  See https://github.com/zKillboard/zKillboard/wiki/Websocket for documentation on the Websocket and supported channels
  """
  use WebSockex
  require Logger
  alias ExZkb.{Parser, Handler}

  @url "wss://zkillboard.com:2096"

  ## Client methods

  @spec start_link(any) :: {:error, any} | {:ok, pid}
  def start_link(state) do
    WebSockex.start_link(@url, __MODULE__, state, name: __MODULE__)
  end

  @doc """
  Send a raw text message to the webhook
  """
  def send(message) do
    Logger.info( "Sending text frame with payload: #{message}")
    WebSockex.send_frame(__MODULE__, {:text, message})
  end

  @doc """
  Subscribe the webhook to a specific channel.
  Received frames will be handled by handle_frame, see below

  Returns `:ok`

  ## Examples

      iex> ExZkb.Client.subscribe("killstream")
      :ok
  """
  def subscribe(channel) do
    Logger.info("Subscribed to channel #{channel}")
    %{"action" => "sub", "channel" => channel}
    |> send_json()
  end

  @doc """
  Unsubscribe from a previously subscribed channel to stop receiving frames from that channel.

  Returns `:ok`

  ## Examples

      iex> ExZkb.Client.unsubscribe("killstream")
  """
  def unsubscribe(channel) do
    Logger.info("Unsubscribed from channel #{channel}")
    %{"action" => "unsub", "channel" => channel}
    |> send_json()
  end

  ## Server callbacks

  def handle_connect(_conn, state) do
    Logger.info("Websocket Connected with state #{state}")
    {:ok, state}
  end

  def handle_frame({:text, msg}, state) do
    case Jason.decode(msg) do
      {:ok, message} -> process_json_frame(message)
      _ -> :ok
    end
    {:ok, state}
  end

  def handle_frame({type, msg}, state) do
    Logger.info("Received unknown Message - Type: #{inspect type} -- Message: #{inspect msg}")
    {:ok, state}
  end

  defp send_json(message) do
    frame = {:text, Jason.encode!(message)}
    WebSockex.send_frame(__MODULE__, frame)
  end

  defp process_json_frame(message) do
    message
    |> Parser.parse()
    |> Handler.handle()
  end
end
