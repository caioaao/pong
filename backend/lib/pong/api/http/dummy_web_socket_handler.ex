defmodule Pong.Api.Http.DummyWebSocketHandler do
  alias Pong.Core.Match.Server, as: MatchServer
  require Logger

  @behaviour :cowboy_websocket

  @possible_events [
    {:player_request, :move_pad_left, :player2},
    {:player_request, :move_pad_right, :player2}
  ]

  def init(request, state) do
    {:cowboy_websocket, request, state}
  end

  def websocket_init(_state) do
    with {:ok, server} <- MatchServer.start_link([]) do
      Process.send(self(), :tick_state, [])
      Process.send(self(), :tick_cmd, [])

      MatchServer.process_event(server, {:player_request, :join_match, :player1})
      MatchServer.process_event(server, {:player_request, :join_match, :player2})

      {:ok, server}
    end
  end

  # heartbeat - ignore
  def websocket_handle({:text, ""}, server) do
    {:ok, server}
  end

  def websocket_handle({:text, "move_left"}, server) do
    MatchServer.process_event(server, {:player_request, :move_pad_left, :player1})
    {:ok, server}
  end

  def websocket_handle({:text, "move_right"}, server) do
    MatchServer.process_event(server, {:player_request, :move_pad_right, :player1})
    {:ok, server}
  end

  def websocket_handle({:text, "pause"}, server) do
    MatchServer.process_event(server, {:player_request, :pause, :player1})
    {:ok, server}
  end

  def websocket_handle({:text, "unpause"}, server) do
    MatchServer.process_event(server, {:player_request, :unpause, :player1})
    {:ok, server}
  end

  def websocket_handle({:text, msg}, server) do
    Logger.warn("unknown message #{msg} received - echoing to client")
    {:reply, {:text, msg}, server}
  end

  def websocket_info(:tick_cmd, server) do
    Process.send_after(self(), :tick_cmd, 400)
    MatchServer.process_event(server, Enum.random(@possible_events))
    {:ok, server}
  end

  def websocket_info(:tick_state, server) do
    Process.send_after(self(), :tick_state, div(1000, 60))
    reply_with_match(MatchServer.state(server), server)
  end

  def websocket_info(_, state) do
    {:ok, state}
  end

  defp reply_with_match(match, ws_state) do
    {:reply, {:text, Pong.WireSchema.Json.Match.marshal(match)}, ws_state}
  end
end
