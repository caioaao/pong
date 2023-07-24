defmodule Pong.Api.Http.WebSocketHandler do
  @behaviour :cowboy_websocket

  alias Pong.Core.Match.Server, as: MatchServer
  alias Pong.Core.Match.Registry.V2, as: MatchRegistry
  require Logger

  @impl true
  def init(request, _) do
    %{player: username, match: match_id} = :cowboy_req.match_qs([:player, :match], request)

    case MatchRegistry.lookup(match_id) do
      {_, match_pid, %{player1: ^username}} ->
        {:cowboy_websocket, request, %{match_pid: match_pid, player: :player1}}

      {_, match_pid, %{player2: ^username}} ->
        {:cowboy_websocket, request, %{match_pid: match_pid, player: :player2}}

      # TODO join as spectator
      _ ->
        {:error, :player_not_in_match}
    end
  end

  @impl true
  def websocket_init(%{match_pid: match_pid} = state) do
    ref = Process.monitor(match_pid)

    Process.send(self(), :poll_state, [])
    {:ok, Map.put(state, :match_ref, ref)}
  end

  @impl true
  # heartbeat - ignore
  def websocket_handle({:text, ""}, server) do
    {:ok, server}
  end

  @impl true
  def websocket_handle({:text, "move_left"}, %{player: player, match_pid: match_pid} = state) do
    MatchServer.process_event(match_pid, {:player_request, :move_pad_left, player})
    {:ok, state}
  end

  @impl true
  def websocket_handle({:text, "move_right"}, %{player: player, match_pid: match_pid} = state) do
    MatchServer.process_event(match_pid, {:player_request, :move_pad_right, player})
    {:ok, state}
  end

  @impl true
  def websocket_handle({:text, "pause"}, %{player: player, match_pid: match_pid} = state) do
    MatchServer.process_event(match_pid, {:player_request, :pause, player})
    {:ok, state}
  end

  @impl true
  def websocket_handle({:text, "unpause"}, %{player: player, match_pid: match_pid} = state) do
    MatchServer.process_event(match_pid, {:player_request, :unpause, player})
    {:ok, state}
  end

  @impl true
  def websocket_handle({:text, msg}, server) do
    Logger.warn("unknown message #{msg} received - echoing to client")
    {:reply, {:text, msg}, server}
  end

  @impl true
  def websocket_info({:DOWN, ref, :process, _, _}, %{match_ref: ref} = state) do
    {:stop, state}
  end

  @impl true
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

  @impl true
  def websocket_info(info, state) do
    {:reply, {:text, info}, state}
  end
end
