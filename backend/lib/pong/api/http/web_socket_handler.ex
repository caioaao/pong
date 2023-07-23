defmodule Pong.Api.Http.WebSocketHandler do
  @behaviour :cowboy_websocket

  alias Pong.Core.Match.Server, as: MatchServer
  require Logger

  def init(request, _state) do
    # FIXME 
    with ["", "ws", match_id, player_id] <- String.split(request.path, "/") do
      case player_id do
        "player1" ->
          {:cowboy_websocket, request, %{match_id: match_id, player: :player1}}

        "player2" ->
          {:cowboy_websocket, request, %{match_id: match_id, player: :player2}}
      end
    end
  end

  def websocket_init(%{match_id: match_id} = state) do
    match_server = Pong.Core.Match.Registry.get_or_create_match(match_id)
    ref = Process.monitor(match_server)

    Process.send(self(), :poll_state, [])
    {:ok, Map.merge(state, %{match_pid: match_server, match_ref: ref})}
  end

  # heartbeat - ignore
  def websocket_handle({:text, ""}, server) do
    {:ok, server}
  end

  def websocket_handle({:text, "move_left"}, %{player: player, match_pid: match_pid} = state) do
    MatchServer.process_event(match_pid, {:player_request, :move_pad_left, player})
    {:ok, state}
  end

  def websocket_handle({:text, "move_right"}, %{player: player, match_pid: match_pid} = state) do
    MatchServer.process_event(match_pid, {:player_request, :move_pad_right, player})
    {:ok, state}
  end

  def websocket_handle({:text, "pause"}, %{player: player, match_pid: match_pid} = state) do
    MatchServer.process_event(match_pid, {:player_request, :pause, player})
    {:ok, state}
  end

  def websocket_handle({:text, "unpause"}, %{player: player, match_pid: match_pid} = state) do
    MatchServer.process_event(match_pid, {:player_request, :unpause, player})
    {:ok, state}
  end

  def websocket_handle({:text, msg}, server) do
    Logger.warn("unknown message #{msg} received - echoing to client")
    {:reply, {:text, msg}, server}
  end

  def websocket_info({:DOWN, ref, :process, _, _}, %{match_ref: ref} = state) do
    {:stop, state}
  end

  def websocket_info(:poll_state, %{match_pid: match_pid} = state) do
    Process.send_after(self(), :poll_state, div(1000, 60))

    match_pid
    |> Pong.Core.Match.Server.state()
    |> Pong.Api.Http.Encode.state_to_wire()
    |> case do
      {:ok, payload} ->
        {:reply, {:text, payload}, state}

      err ->
        Logger.error("failed to encode state", err)
        {:close, state}
    end
  end

  def websocket_info(info, state) do
    {:reply, {:text, info}, state}
  end
end
