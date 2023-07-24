defmodule Pong.Api.Http.DummyWebSocketHandler do
  alias Pong.Core.Match.Server, as: MatchServer
  alias Pong.Api.Http.WebSocket.{MatchSubscription}
  require Logger

  @behaviour :cowboy_websocket

  @possible_events [
    {:player_request, :move_pad_left, :player2},
    {:player_request, :move_pad_right, :player2}
  ]

  @impl true
  def init(request, state) do
    {:cowboy_websocket, request, state}
  end

  @impl true
  def websocket_init(_state) do
    with {:ok, server} <- MatchServer.start_link([]) do
      MatchServer.subscribe(server, MatchSubscription.child_spec(self()))

      MatchServer.process_event(server, {:player_request, :join_match, :player1})
      MatchServer.process_event(server, {:player_request, :join_match, :player2})

      Process.send(self(), :tick_cmd, [])

      {:ok, server}
    end
  end

  # heartbeat - ignore
  @impl true
  def websocket_handle({:text, ""}, server) do
    {:ok, server}
  end

  @impl true
  def websocket_handle({:text, "move_left"}, server) do
    MatchServer.process_event(server, {:player_request, :move_pad_left, :player1})
    {:ok, server}
  end

  @impl true
  def websocket_handle({:text, "move_right"}, server) do
    MatchServer.process_event(server, {:player_request, :move_pad_right, :player1})
    {:ok, server}
  end

  @impl true
  def websocket_handle({:text, "pause"}, server) do
    MatchServer.process_event(server, {:player_request, :pause, :player1})
    {:ok, server}
  end

  @impl true
  def websocket_handle({:text, "unpause"}, server) do
    MatchServer.process_event(server, {:player_request, :unpause, :player1})
    {:ok, server}
  end

  @impl true
  def websocket_handle({:text, msg}, server) do
    Logger.warn("unknown message #{msg} received - echoing to client")
    {:reply, {:text, msg}, server}
  end

  def websocket_info(:tick_cmd, server) do
    Process.send_after(self(), :tick_cmd, 400)
    MatchServer.process_event(server, Enum.random(@possible_events))
    {:ok, server}
  end

  @impl true
  def websocket_info({:match_state, match}, server) do
    reply_with_match(match, server)
  end

  @impl true
  def websocket_info(_, state) do
    {:ok, state}
  end

  defp reply_with_match(match, ws_state) do
    {:reply, {:text, Pong.WireSchema.Json.Match.marshal(match)}, ws_state}
  end
end
