defmodule Pong.Api.Http.WebSocket.MatchSubscription do
  use GenServer

  def start_link(init_arg, opts \\ []) do
    GenServer.start_link(__MODULE__, init_arg, opts)
  end

  @impl true
  def init(ws_pid) do
    IO.inspect(ws_pid)
    {:ok, ws_pid}
  end

  @impl true
  def handle_cast({:match_state, match}, ws_pid) do
    Process.send(ws_pid, {:match_state, match}, [])
    {:noreply, ws_pid}
  end
end
