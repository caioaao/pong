defmodule Pong.Core.MatchTest do
  use ExUnit.Case, async: true

  alias Pong.Core.{Match, Ball, PlayerPad}

  describe "generate id" do
    test "generated ids match regex" do
      Stream.repeatedly(fn -> Match.gen_id() end)
      |> Enum.take(50)
      |> Enum.each(fn testcase ->
        assert Regex.match?(~r/[a-zA-Z0-9]+/, testcase)
      end)
    end

    test "generated ids have correct length" do
      Stream.repeatedly(fn -> :rand.uniform(50) end)
      |> Enum.take(50)
      |> Enum.each(fn len ->
        got = Pong.Core.Match.gen_id(len)
        assert String.length(got) == len
      end)
    end
  end

  describe "record point during match" do
    test "resets ball" do
      match_after_score =
        Match.start()
        |> Map.update!(:ball, &Ball.update_position(&1, 1000))
        |> Match.record_point(:player1)

      assert match_after_score[:ball] == Match.start()[:ball]
    end

    test "does not reset pads" do
      match_before_score =
        Match.start()
        |> Map.update!(:player1_pad, &PlayerPad.move_left/1)
        |> Map.update!(:player2_pad, &PlayerPad.move_right/1)

      match_after_score =
        match_before_score
        |> Match.record_point(:player2)

      assert match_after_score[:player1_pad] == match_before_score[:player1_pad]
      assert match_after_score[:player2_pad] == match_before_score[:player2_pad]
    end

    test "increases score" do
      match0 = Match.start() |> Map.put(:score, {1, 7})

      assert Match.record_point(match0, :player1) |> Map.get(:score) == {2, 7}
      assert Match.record_point(match0, :player2) |> Map.get(:score) == {1, 8}
    end

    test "detects winning score" do
      assert Match.start() |> Map.put(:score, {10, 10}) |> Match.record_point(:player1) == %{
               state: :finished,
               winner: :player1,
               final_score: {11, 10}
             }

      assert Match.start() |> Map.put(:score, {10, 10}) |> Match.record_point(:player2) == %{
               state: :finished,
               winner: :player2,
               final_score: {10, 11}
             }

      assert Match.start() |> Map.put(:score, {0, 10}) |> Match.record_point(:player2) == %{
               state: :finished,
               winner: :player2,
               final_score: {0, 11}
             }

      assert Match.start() |> Map.put(:score, {10, 0}) |> Match.record_point(:player1) == %{
               state: :finished,
               winner: :player1,
               final_score: {11, 0}
             }
    end
  end

  describe "detect ball collision" do
    test "collides with left wall" do
      assert Match.ball_collision(%{
               ball: %{geometry: %{center: {1, 12}, radius: 1}, velocity: {10, 10}},
               field: {30, 30},
               player1_pad: random_player_pad(),
               player2_pad: random_player_pad()
             }) == :left_wall
    end

    test "collides with right wall" do
      assert Match.ball_collision(%{
               ball: %{geometry: %{center: {29, 12}, radius: 1}, velocity: {10, 10}},
               field: {30, 30},
               player1_pad: random_player_pad(),
               player2_pad: random_player_pad()
             }) == :right_wall
    end

    test "collides with top wall" do
      assert Match.ball_collision(%{
               ball: %{geometry: %{center: {8, 29}, radius: 1}, velocity: {10, 10}},
               field: {30, 30},
               player1_pad: random_player_pad(),
               player2_pad: random_player_pad()
             }) == :top_wall
    end

    test "collides with bottom wall" do
      assert Match.ball_collision(%{
               ball: %{geometry: %{center: {8, 1}, radius: 1}, velocity: {10, 10}},
               field: {30, 30},
               player1_pad: random_player_pad(),
               player2_pad: random_player_pad()
             }) == :bottom_wall
    end

    test "collides with player 1's pad" do
      assert Match.ball_collision(%{
               ball: %{geometry: %{center: {8, 8}, radius: 1}, velocity: {10, 10}},
               field: {30, 30},
               player1_pad: %{geometry: %{center: {7, 7}, width: 2, height: 2}},
               player2_pad: random_player_pad()
             }) == :player1_pad
    end

    test "collides with player 2's pad" do
      assert Match.ball_collision(%{
               ball: %{geometry: %{center: {8, 8}, radius: 1}, velocity: {10, 10}},
               field: {30, 30},
               player1_pad: random_player_pad(),
               player2_pad: %{geometry: %{center: {7, 7}, width: 2, height: 2}}
             }) == :player2_pad
    end
  end

  defp random_player_pad() do
    %{
      geometry: %{
        center: {:rand.uniform(), :rand.uniform()},
        width: :rand.uniform(),
        height: :rand.uniform()
      }
    }
  end
end
