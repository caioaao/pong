defmodule Pong.Core.MatchTest do
  use ExUnit.Case, async: true

  test "generated ids match regex" do
    Stream.repeatedly(fn -> Pong.Core.Match.gen_id() end)
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
