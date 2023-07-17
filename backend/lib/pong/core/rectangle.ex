defmodule Pong.Core.Rectangle do
  alias Pong.Core.{Point, LineSegment, Circle, Vector}

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

  @spec move(t(), Vector.t()) :: t()
  def move(rect, vec) do
    update_in(rect, [:center], &Vector.add(&1, vec))
  end

  @spec ensure_inside_viewport(t(), number(), number()) :: t()
  def ensure_inside_viewport(rect, viewportWidth, viewportHeight) do
    update_in(rect, [:center], fn {x, y} ->
      {
        x |> min(viewportWidth - rect[:width] / 2) |> max(rect[:width] / 2),
        y |> min(viewportHeight - rect[:height] / 2) |> max(rect[:height] / 2)
      }
    end)
  end
end
