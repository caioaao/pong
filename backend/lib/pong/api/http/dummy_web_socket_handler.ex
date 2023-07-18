defmodule Pong.Api.Http.DummyWebSocketHandler do
  alias Pong.Core.Match.Server, as: MatchServer
  require Logger

  @behaviour :cowboy_websocket
  require Logger
  require Jason

  @possible_commands [
    {:move_left, :player2},
    {:move_right, :player2}
  ]

  def init(request, state) do
    {:cowboy_websocket, request, state}
  end

  def websocket_init(_state) do
    with {:ok, server} <- MatchServer.start_link([]) do
      Process.send(self(), :tick_state, [])
      Process.send(self(), :tick_cmd, [])

      {:ok, server}
    end
  end

  # heartbeat - ignore
  def websocket_handle({:text, ""}, server) do
    {:ok, server}
  end

  def websocket_handle({:text, "move_left"}, server) do
    MatchServer.process_command(server, {:move_left, :player1})
    {:ok, server}
  end

  def websocket_handle({:text, "move_right"}, server) do
    MatchServer.process_command(server, {:move_right, :player1})
    {:ok, server}
  end

  def websocket_handle({:text, "pause"}, server) do
    MatchServer.process_command(server, {:pause, :player1})
    {:ok, server}
  end

  def websocket_handle({:text, "unpause"}, server) do
    MatchServer.process_command(server, {:unpause, :player1})
    {:ok, server}
  end

  def websocket_handle({:text, msg}, server) do
    Logger.warn("unknown message #{msg} received - echoing to client")
    {:reply, {:text, msg}, server}
  end

  def websocket_info(:tick_cmd, server) do
    Process.send_after(self(), :tick_cmd, 400)
    MatchServer.process_command(server, Enum.random(@possible_commands))
    {:ok, server}
  end

  def websocket_info(:tick_state, server) do
    Process.send_after(self(), :tick_state, div(1000, 60))
    reply_with_game_state(MatchServer.state(server), server)
  end

  def websocket_info(_, state) do
    {:ok, state}
  end

  defp reply_with_game_state(s, state) do
    s
    |> Pong.Api.Http.Encode.state_to_wire()
    |> case do
      {:ok, payload} ->
        {:reply, {:text, payload}, state}

      err ->
        Logger.error("failed to encode state", err)
        {:close, state}
    end
  end
end
