defmodule Pong.Core.Match.Registry do
  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, Keyword.merge([name: __MODULE__], opts))
  end

  @spec lookup_match(String.t()) :: pid()
  def lookup_match(name) do
    GenServer.call(__MODULE__, {:lookup, name})
  end

  @spec get_or_create_match(String.t()) :: pid()
  def get_or_create_match(name) do
    GenServer.call(__MODULE__, {:get_or_create, name})
  end

  @impl true
  def init(:ok) do
    matches_by_name = %{}
    names_by_ref = %{}
    {:ok, {matches_by_name, names_by_ref}}
  end

  @impl true
  def handle_call({:lookup, name}, _from, {matches_by_name, _} = state) do
    {:reply, Map.fetch(matches_by_name, name), state}
  end

  @impl true
  def handle_call({:get_or_create, name}, _from, {matches_by_name, names_by_ref} = state) do
    case Map.fetch(matches_by_name, name) do
      {:ok, match_pid} ->
        {:reply, match_pid, state}

      :error ->
        with {:ok, match_pid} <-
               DynamicSupervisor.start_child(
                 Pong.Core.Match.ServerSupervisor,
                 Pong.Core.Match.Server
               ) do
          ref = Process.monitor(match_pid)
          names_by_ref = Map.put(names_by_ref, ref, name)
          matches_by_name = Map.put(matches_by_name, name, match_pid)
          {:reply, match_pid, {matches_by_name, names_by_ref}}
        end
    end
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _pid, _reason}, {matches_by_name, names_by_ref}) do
    {name, names_by_ref} = Map.pop(names_by_ref, ref)
    matches_by_name = Map.delete(matches_by_name, name)
    {:noreply, {matches_by_name, names_by_ref}}
  end

  @impl true
  def handle_info(msg, state) do
    Logger.debug("unexpected message in #{__MODULE__}: #{inspect(msg)}")
    {:noreply, state}
  end
end
