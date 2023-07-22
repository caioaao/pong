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
end
