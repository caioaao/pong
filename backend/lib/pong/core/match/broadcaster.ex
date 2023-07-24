defmodule Pong.Core.Match.Broadcaster do
  @moduledoc """
  Each event handler is its own GenServer and should be spawned by the event
  manager using the `add_handler` interface. This is directly inspired by Jose
  Valim's post about replacing GenEvent with GenServer + Supervisor [1] in
  ExUnit. In this case we use a dynamic supervisor instead of the deprecated
  :simple_one_for_one strategy

  [1] https://blog.plataformatec.com.br/2016/11/replacing-genevent-by-a-supervisor-genserver/
  """
  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg)
  end

  @spec add_handler(pid(), Supervisor.child_spec()) :: :ok
  def(add_handler(sup, child_spec)) do
    {:ok, _} = DynamicSupervisor.start_child(sup, child_spec)
    :ok
  end

  def broadcast(sup, match) do
    for {_, child_pid, _, _} <- DynamicSupervisor.which_children(sup) do
      GenServer.cast(child_pid, {:match_state, match})
    end
  end

  @impl true
  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
