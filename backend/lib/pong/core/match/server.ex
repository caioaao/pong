defmodule Pong.Core.Match.Server do
  use GenServer, restart: :temporary
  alias Pong.Core.{Match}
  alias Pong.Core.Match.{Event, StateMachine}

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

  @spec process_event(pid(), Event.t()) :: :ok
  def process_event(server, evt) do
    GenServer.cast(server, {:process_event, evt})
  end

  @spec state(pid()) :: GameState.t()
  def state(server) do
    GenServer.call(server, :lookup_state)
  end

  @impl true
  def init([]) do
    {:ok, Match.start()}
  end

  @impl true
  def handle_call(:lookup_state, _from, match_state) do
    {:reply, match_state, match_state}
  end

  @impl true
  def handle_cast({:process_event, evt}, match_state) do
    {:noreply, StateMachine.process_event(match_state, evt)}
  end

  @impl true
  def handle_info(:tick, match_state) do
    new_state = StateMachine.process_event(match_state, {:tick, @fixed_delta_time_millis})

    unless StateMachine.halt?(new_state) do
      schedule_next_update(self())
    end

    {:noreply, new_state}
  end

  defp schedule_next_update(server) do
    Process.send_after(server, :tick, @fixed_delta_time_millis)
  end
end
