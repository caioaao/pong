defmodule Pong.Core.Match.Registry.V2 do
  alias Pong.Core.Match
  alias Pong.Core.Match.Server, as: MatchServer

  @type match_metadata() :: %{player1: String.t(), player2: String.t()}
  @type entry() :: {Match.id(), pid(), match_metadata()}

  def start_link do
    Registry.start_link(keys: :unique, name: __MODULE__)
  end

  def child_spec(_) do
    Registry.child_spec(keys: :unique, name: Pong.Core.Match.Registry.V2)
  end

  @spec start_match(player1: String.t(), player2: String.t()) :: entry()
  def start_match([player1: player1, player2: player2] = opts) do
    match_id = Match.gen_id()
    metadata = %{player1: player1, player2: player2}

    case MatchServer.start_link(name: {:via, Registry, {__MODULE__, match_id, metadata}}) do
      {:ok, match_pid} -> {match_id, match_pid, metadata}
      {:error, {:already_started, _}} -> start_match(opts)
    end
  end

  @spec lookup(String.t()) :: {:ok, entry()} | {:error, :match_not_found}
  def lookup(match_id) do
    case Registry.lookup(__MODULE__, match_id) do
      [{match_pid, match_metadata}] -> {:ok, {match_id, match_pid, match_metadata}}
      [] -> {:error, :match_not_found}
    end
  end
end
