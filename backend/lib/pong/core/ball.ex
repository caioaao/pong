defmodule Pong.Core.Ball do
  alias Pong.Core.{Circle, Vector, Point}

  @type t() :: %{geometry: Circle.t(), velocity: Vector.t()}

  def speed, do: 60
  def radius, do: 5
  def initial_velocity, do: {0, -speed()}

  @spec redirect_away_from_point(t(), Point.t()) :: t()
  def redirect_away_from_point(ball, point) do
    Map.put(
      ball,
      :velocity,
      Vector.sub(ball[:geometry][:center], point)
      |> Vector.direction()
      |> Vector.scale(Vector.magnitude(ball[:velocity]))
    )
  end

  @spec update_position(t(), number()) :: t()
  def update_position(ball, ellapsed_millis) do
    displacement = Vector.scale(ball[:velocity], ellapsed_millis / 1000)
    Map.update!(ball, :geometry, &Circle.move(&1, displacement))
  end
end
