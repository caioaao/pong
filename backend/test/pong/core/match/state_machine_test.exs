defmodule Pong.Core.Match.StateMachineTest do
  use ExUnit.Case, async: true

  alias Pong.Core.{Match}
  alias Pong.Core.Match.{StateMachine}

  test "happy path" do
    s0 = Match.create()

    events = [
      {:tick, 10},
      {:player_request, :join_match, :player2},
      {:player_request, :join_match, :player1},
      {:tick, 100},
      {:tick, 33},
      {:tick, 3000},
      {:player_request, :move_left, :player1},
      {:player_request, :move_left, :player1},
      {:player_request, :move_left, :player1},
      {:tick, 100}
    ]

    expected_states = [
      %{state: :created, millis_left_until_timeout: 59990, players_ready: %MapSet{}},
      %{state: :created, millis_left_until_timeout: 59990, players_ready: MapSet.new([:player2])},
      %{
        state: :starting,
        millis_left_until_start: 3000
      },
      %{
        state: :starting,
        millis_left_until_start: 2900
      },
      %{
        state: :starting,
        millis_left_until_start: 2867
      },
      Match.start(),
      %{
        ball: %{geometry: %{center: {50, 50}, radius: 5}, velocity: {0, -60}},
        field: {100, 100},
        player1_pad: %{geometry: %{center: {45, 10}, height: 2, width: 20}},
        player2_pad: %{geometry: %{center: {50, 90}, height: 2, width: 20}},
        score: {0, 0},
        state: :in_progress
      },
      %{
        ball: %{geometry: %{center: {50, 50}, radius: 5}, velocity: {0, -60}},
        field: {100, 100},
        player1_pad: %{geometry: %{center: {40, 10}, height: 2, width: 20}},
        player2_pad: %{geometry: %{center: {50, 90}, height: 2, width: 20}},
        score: {0, 0},
        state: :in_progress
      },
      %{
        ball: %{geometry: %{center: {50, 50}, radius: 5}, velocity: {0, -60}},
        field: {100, 100},
        player1_pad: %{geometry: %{center: {35, 10}, height: 2, width: 20}},
        player2_pad: %{geometry: %{center: {50, 90}, height: 2, width: 20}},
        score: {0, 0},
        state: :in_progress
      },
      %{
        ball: %{geometry: %{center: {50, 44}, radius: 5}, velocity: {0, -60}},
        field: {100, 100},
        player1_pad: %{geometry: %{center: {35, 10}, height: 2, width: 20}},
        player2_pad: %{geometry: %{center: {50, 90}, height: 2, width: 20}},
        score: {0, 0},
        state: :in_progress
      }
    ]

    Enum.zip_reduce([events, expected_states], s0, fn [evt, expected_state], curr_state ->
      new_state = StateMachine.process_event(curr_state, evt)
      assert new_state == expected_state
      new_state
    end)
  end
end
