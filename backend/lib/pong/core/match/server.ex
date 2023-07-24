defmodule Pong.Core.Match.Server do
  use GenServer, restart: :temporary
  alias Pong.Core.{Match}
  alias Pong.Core.Match.{Event, StateMachine, Broadcaster}

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

  def subscribe(server, child_spec) do
    GenServer.call(server, {:add_subscription, child_spec})
  end

  @impl true
  def init([]) do
    with {:ok, broadcaster} <- DynamicSupervisor.start_link(Broadcaster, []) do
      match = Match.create()
      Broadcaster.broadcast(broadcaster, match)

      {:ok,
       %{
         match: match,
         match_broadcaster: broadcaster
       }}
    end
  end

  @impl true
  def handle_call(:lookup_state, _from, state) do
    {:reply, state[:match], state}
  end

  @impl true
  def handle_call({:add_subscription, child_spec}, _from, state) do
    Broadcaster.add_handler(state[:match_broadcaster], child_spec)
    {:reply, :ok, state}
  end

  @impl true
  def handle_cast({:process_event, evt}, state) do
    {:noreply, update_and_broadcast_match(state, evt)}
  end

  @impl true
  def handle_info(:tick, state) do
    new_state = update_and_broadcast_match(state, {:tick, @fixed_delta_time_millis})

    unless StateMachine.halt?(new_state[:match]) do
      schedule_next_update(self())
    end

    {:noreply, new_state}
  end

  defp schedule_next_update(server) do
    Process.send_after(server, :tick, @fixed_delta_time_millis)
  end

  defp update_and_broadcast_match(
         %{match: match, match_broadcaster: match_broadcaster} = state,
         evt
       ) do
    match = StateMachine.process_event(match, evt)
    Broadcaster.broadcast(match_broadcaster, match)
    Map.put(state, :match, match)
  end
end
