defmodule Pong.Api.Http.DummyWebSocketHandler do
  @behaviour :cowboy_websocket
  require Logger
  require Jason

  def init(request, state) do
    {:cowboy_websocket, request, state}
  end

  def websocket_init(_state) do
    Process.send(self(), :tick, [])

    {:ok,
     %{
       game_state: %{
         ball: %{pos: {10, 3}, velocity: {0, 0}},
         player1_pad: %{pos: {43, 20}},
         player2_pad: %{pos: {32, 90}},
         score: {32, 2}
       }
     }}
  end

  def websocket_handle({:text, msg}, state) do
    {:reply, {:text, msg}, state}
  end

  def websocket_info(:tick, %{game_state: game_state} = state) do
    Process.send_after(self(), :tick, 1000)
    Logger.info("sending msg")
    reply_with_game_state(game_state, state)
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
