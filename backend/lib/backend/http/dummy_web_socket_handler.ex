defmodule Backend.Http.DummyWebSocketHandler do
  @behaviour :cowboy_websocket
  require Logger

  def init(request, state) do
    {:cowboy_websocket, request, state}
  end

  def websocket_init(state) do
    Process.send(self(), :tick, [])
    {:ok, state}
  end

  def websocket_handle({:text, msg}, state) do
    {:reply, {:text, msg}, state}
  end

  def websocket_info(:tick, state) do
    Process.send_after(self(), :tick, 1000)
    Logger.info("sending tick")
    {:reply, {:text, "pong"}, state}
  end

  def websocket_info(_, state) do
    {:ok, state}
  end
end
