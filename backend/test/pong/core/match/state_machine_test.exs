defmodule Pong.Core.Match.StateMachineTest.StateTransition do
  defmacro test(description, initial_state, evt, expected) do
    quote do
      test unquote(description) do
        assert Pong.Core.Match.StateMachine.process_event(unquote(initial_state), unquote(evt)) ==
                 unquote(expected)
      end
    end
  end
end

defmodule Pong.Core.Match.StateMachineTest do
  use ExUnit.Case, async: true

  require Pong.Core.Match.StateMachineTest.StateTransition
  alias Pong.Core.Match.StateMachineTest.{StateTransition}

  StateTransition.test(
    "from created with small tick",
    %{state: :created, millis_left_until_timeout: 100, players_ready: %MapSet{}},
    {:tick, 10},
    %{state: :created, millis_left_until_timeout: 90, players_ready: %MapSet{}}
  )

  StateTransition.test(
    "from created with delta time matching millis left",
    %{state: :created, millis_left_until_timeout: 100, players_ready: %MapSet{}},
    {:tick, 100},
    %{state: :canceled}
  )

  StateTransition.test(
    "from created with big delta time matching millis",
    %{state: :created, millis_left_until_timeout: 100, players_ready: %MapSet{}},
    {:tick, 1000},
    %{state: :canceled}
  )

  StateTransition.test(
    "player 1 joins created match",
    %{state: :created, millis_left_until_timeout: 100, players_ready: %MapSet{}},
    {:player_request, :join_match, :player1},
    %{state: :created, millis_left_until_timeout: 100, players_ready: MapSet.new([:player1])}
  )

  StateTransition.test(
    "has no effect if player 1 joins created match again",
    %{state: :created, millis_left_until_timeout: 100, players_ready: MapSet.new([:player1])},
    {:player_request, :join_match, :player1},
    %{state: :created, millis_left_until_timeout: 100, players_ready: MapSet.new([:player1])}
  )

  StateTransition.test(
    "player 2 joins created match after player 1",
    %{state: :created, millis_left_until_timeout: 100, players_ready: MapSet.new([:player1])},
    {:player_request, :join_match, :player2},
    %{state: :starting, millis_left_until_start: 3000}
  )

  StateTransition.test(
    "player 2 joins created match before player 1",
    %{state: :created, millis_left_until_timeout: 100, players_ready: %MapSet{}},
    {:player_request, :join_match, :player2},
    %{state: :created, millis_left_until_timeout: 100, players_ready: MapSet.new([:player2])}
  )

  StateTransition.test(
    "receiving small tick on created after a player joins",
    %{state: :created, millis_left_until_timeout: 100, players_ready: MapSet.new([:player1])},
    {:tick, 10},
    %{state: :created, millis_left_until_timeout: 90, players_ready: MapSet.new([:player1])}
  )

  StateTransition.test(
    "match times out after player joins",
    %{state: :created, millis_left_until_timeout: 100, players_ready: MapSet.new([:player1])},
    {:tick, 100},
    %{state: :canceled}
  )

  StateTransition.test(
    "receiving small tick when starting",
    %{state: :starting, millis_left_until_start: 100},
    {:tick, 13},
    %{state: :starting, millis_left_until_start: 87}
  )

  StateTransition.test(
    "from starting with delta time matching millis left",
    %{state: :starting, millis_left_until_start: 1230},
    {:tick, 1230},
    %{state: :in_progress}
  )

  StateTransition.test(
    "from starting with delta time bigger than millis left",
    %{state: :starting, millis_left_until_start: 1230},
    {:tick, 9001},
    %{state: :in_progress}
  )
end
