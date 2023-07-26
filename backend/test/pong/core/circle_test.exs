defmodule Pong.Core.CircleTest do
  use ExUnit.Case, async: true

  alias Pong.Core.{Circle}

  test "intersects line segment in one point" do
    assert Circle.intersects_line_segment?(%{center: {0, 0}, radius: 1}, {{0, 0}, {10, 0}})
  end

  test "intersects line segment in more than one point" do
    assert Circle.intersects_line_segment?(%{center: {0, 0}, radius: 2}, {{0, 0}, {10, 0}})
  end
end
