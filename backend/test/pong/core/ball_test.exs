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

  test "center point, point moving away from, and direction vector are collinear after moving away" do
    Enum.to_list(1..100)
    |> Enum.each(fn _ ->
      ball_center = random_coords()
      pt = random_coords()

      ball =
        %{
          geometry: %{center: ball_center, radius: :rand.uniform(20)},
          velocity: random_coords()
        }
        |> Ball.redirect_away_from_point(pt)

      assert abs(Vector.cross(Vector.sub(ball_center, pt), ball[:velocity])) < 1.0e-6
    end)
  end

  defp random_coords(), do: {:rand.uniform(100), :rand.uniform(100)}
end
