defmodule Pong.Core.BallTest do
  use ExUnit.Case, async: true

  alias Pong.Core.{Ball, Vector}

  test "moving away from point preserves speed" do
    Stream.repeatedly(fn -> {:rand.uniform(100), :rand.uniform(100)} end)
    |> Enum.take(100)
    |> Enum.each(fn initial_velocity ->
      ball =
        %{
          geometry: %{center: random_coords(), radius: 1},
          velocity: initial_velocity
        }
        |> Ball.redirect_away_from_point(random_coords())

      assert_in_delta Vector.magnitude(ball[:velocity]),
                      Vector.magnitude(initial_velocity),
                      1.0e-6
    end)
  end

  defp random_coords(), do: {:rand.uniform(100), :rand.uniform(100)}
end
