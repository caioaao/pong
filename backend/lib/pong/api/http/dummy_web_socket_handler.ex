defmodule Pong.Api.Http.DummyWebSocketHandler do
  @behaviour :cowboy_websocket
  require Logger
  require Jason

  @possible_commands [
    {:move_left, :player1},
    {:move_left, :player2},
    {:move_right, :player1},
    {:move_right, :player2}
  ]

  def init(request, state) do
    {:cowboy_websocket, request, state}
  end

  def websocket_init(_state) do
    Process.send(self(), :tick_state, [])
    Process.send(self(), :tick_cmd, [])

    {:ok, %{game_state: Pong.Core.GameState.new()}}
  end

  def websocket_handle({:text, msg}, state) do
    {:reply, {:text, msg}, state}
  end

  def websocket_info(:tick_cmd, %{game_state: game_state} = state) do
    Process.send_after(self(), :tick_cmd, 1000)
    cmd = Enum.random(@possible_commands)
    game_state = Pong.Core.GameState.process_command(game_state, cmd)

    {:ok, Map.put(state, :game_state, game_state)}
  end

  def websocket_info(:tick_state, %{game_state: game_state} = state) do
    Process.send_after(self(), :tick_state, div(1000, 60))
    game_state = Pong.Core.GameState.update(game_state, div(1000, 60))

    reply_with_game_state(game_state, Map.put(state, :game_state, game_state))
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
