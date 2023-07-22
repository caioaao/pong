defmodule Pong.Core.CircleTest do
  use ExUnit.Case, async: true

  alias Pong.Core.{Circle}

  test "move circle back to inside a field" do
    assert Circle.ensure_inside_field(%{center: {-13, 43}, radius: 2}, {10, 10}) == %{
             center: {2, 8},
             radius: 2
           }
  end

  test "intersects line segment in one point" do
    assert Circle.intersects_line_segment?(%{center: {0, 0}, radius: 1}, {{0, 0}, {10, 0}})
  end

  test "intersects line segment in more than one point" do
    assert Circle.intersects_line_segment?(%{center: {0, 0}, radius: 2}, {{0, 0}, {10, 0}})
  end
end
