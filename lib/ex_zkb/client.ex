defmodule ExZkb.Client do
  @moduledoc """
  Websocket Client for zkillboard

  See https://github.com/zKillboard/zKillboard/wiki/Websocket for documentation on the Websocket and supported channels
  """
  use WebSockex
  require Logger
  alias ExZkb.{Parser, Handler}

  @url "wss://zkillboard.com:2096"
  @process_name __MODULE__

  ## Client methods

  @spec start_link(any) :: {:error, any} | {:ok, pid}
  def start_link(_) do
    state = %{channels: MapSet.new(["killstream"])}
    WebSockex.start_link(@url, __MODULE__, state, name: @process_name)
  end

  @doc """
  Send a raw text message to the webhook
  """
  def send(message) do
    Logger.debug("Sending text frame with payload: #{message}")
    WebSockex.send_frame(@process_name, {:text, message})
  end

  @doc """
  Subscribe the webhook to a specific channel.
  Received frames will be handled by handle_frame, see below

  Returns `:ok`

  ## Examples

      iex> ExZkb.Client.subscribe("killstream")
      :ok
  """
  def subscribe(channel) when is_binary(channel) do
    Logger.info("Subscribed to channel #{channel}")
    WebSockex.cast(@process_name, {:subscribe, channel})
  end

  @doc """
  Subscribe to multiple channels at once.

  Returns

  ##
  """
  def subscribe(%MapSet{} = channels) do
    channels
    |> Enum.map(&subscribe/1)
  end

  @doc """
  Unsubscribe from a previously subscribed channel to stop receiving frames from that channel.

  Returns `:ok`

  ## Examples

      iex> ExZkb.Client.unsubscribe("killstream")
  """
  def unsubscribe(channel) do
    Logger.info("Unsubscribed from channel #{channel}")
    WebSockex.cast(@process_name, {:unsubscribe, channel})
  end

  ## Server callbacks

  def handle_connect(_conn, state) do
    Logger.info("Websocket Connected with state #{inspect(state)}")

    case state[:channels] do
      %MapSet{} = channels -> subscribe(channels)
      nil -> :noop
    end

    {:ok, state}
  end

  def handle_cast({:subscribe, channel}, state) do
    new_state =
      Map.update(state, :channels, MapSet.new([channel]), fn c -> MapSet.put(c, channel) end)

    message = %{"action" => "sub", "channel" => channel}
    frame = {:text, Jason.encode!(message)}
    {:reply, frame, new_state}
  end

  def handle_cast({:unsubscribe, channel}, state) do
    new_state =
      Map.update(state, :channels, MapSet.new([]), fn c -> MapSet.delete(c, channel) end)

    message = %{"action" => "unsub", "channel" => channel}
    frame = {:text, Jason.encode!(message)}
    {:reply, frame, new_state}
  end

  def handle_frame({:text, msg}, state) do
    case Jason.decode(msg) do
      {:ok, message} -> process_json_frame(message)
      _ -> :ok
    end

    {:ok, state}
  end

  def handle_frame({type, msg}, state) do
    Logger.info("Received unknown Message - Type: #{inspect(type)} -- Message: #{inspect(msg)}")
    {:ok, state}
  end

  defp process_json_frame(message) do
    message
    |> Parser.parse()
    |> Handler.handle()
  end
end
