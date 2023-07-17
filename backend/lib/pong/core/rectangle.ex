defmodule Pong.Core.Rectangle do
  alias Pong.Core.{Point, LineSegment, Circle}

  @type t() :: %{center: Point.t(), width: number(), height: number()}

  @spec edges(t()) :: {LineSegment.t(), LineSegment.t(), LineSegment.t(), LineSegment.t()}
  def edges(rect) do
    {a, b, c, d} = vertices(rect)

    {
      {a, b},
      {b, c},
      {c, d},
      {d, a}
    }
  end

  @doc """
  Returns rectangles vertices in counter-clockwise order, starting from the top-right vertex
  """
  @spec vertices(t()) :: {Point.t(), Point.t(), Point.t(), Point.t()}
  def vertices(%{center: {x, y}, width: width, height: height}) do
    dx = width / 2
    dy = height / 2

    {
      {x + dx, y + dy},
      {x - dx, y + dy},
      {x - dx, y - dy},
      {x + dx, y - dy}
    }
  end

  @spec intersects_circle?(t(), Circle.t()) :: boolean()
  def intersects_circle?(rect, circle) do
    Circle.intersects_rectangle?(circle, rect)
  end
end
