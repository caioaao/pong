defmodule Pong.Core.Match.Server do
  use GenServer, restart: :temporary
  alias Pong.Core.{GameState}

  # tick rate in Hz
  @tick_rate 64
  @fixed_delta_time_millis div(1000, @tick_rate)

  def start_link(opts) do
    case GenServer.start_link(__MODULE__, [], opts) do
      {:ok, pid} ->
        schedule_next_update(pid)
        {:ok, pid}

      err ->
        err
    end
  end

  def process_command(server, cmd) do
    GenServer.cast(server, {:process_command, cmd})
  end

  @spec state(pid()) :: GameState.t()
  def state(server) do
    GenServer.call(server, :lookup_state)
  end

  @impl true
  def init([]) do
    {:ok, GameState.new()}
  end

  @impl true
  def handle_call(:lookup_state, _from, game_state) do
    {:reply, game_state, game_state}
  end

  @impl true
  def handle_cast({:process_command, cmd}, game_state) do
    {:noreply, GameState.process_command(game_state, cmd)}
  end

  @impl true
  def handle_info(:tick, game_state) do
    {result, new_state} = GameState.next(game_state, @fixed_delta_time_millis)

    if result == :cont do
      schedule_next_update(self())
    end

    {:noreply, new_state}
  end

  defp schedule_next_update(server) do
    Process.send_after(server, :tick, @fixed_delta_time_millis)
  end
end
