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

    test "resets pads" do
      match_after_score =
        Match.start()
        |> Map.update!(:player1_pad, &PlayerPad.move_left/1)
        |> Map.update!(:player2_pad, &PlayerPad.move_right/1)
        |> Match.record_point(:player2)

      assert match_after_score[:player1_pad] == Match.start()[:player1_pad]
      assert match_after_score[:player2_pad] == Match.start()[:player2_pad]
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
end
