defmodule Pong.Core.PlayerPadTest do
  alias Pong.Core.{PlayerPad}
  use ExUnit.Case, async: true

  test "pad never leaves viewport" do
    field = {100, 100}
    initial_state = %{geometry: %{center: {0, 0}, width: 1, height: 1}}

    %{geometry: %{center: {final_x, _}}} =
      Enum.reduce([1..50], initial_state, fn _, state -> PlayerPad.move_left(state, field) end)

    assert final_x >= 0

    %{geometry: %{center: {final_x, _}}} =
      Enum.reduce([1..50], initial_state, fn _, state -> PlayerPad.move_right(state, field) end)

    assert final_x <= 100
  end
end
