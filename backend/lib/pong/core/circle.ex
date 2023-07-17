defmodule Pong.Core.Circle do
  alias Pong.Core.{Point, LineSegment, Rectangle, Vector, Viewport}

  @type t() :: %{radius: number(), center: Point.t()}

  @spec intersects_line_segment?(t(), LineSegment.t()) :: boolean()
  def intersects_line_segment?(circle, segment) do
    LineSegment.distance_to_point(segment, circle[:center]) < circle[:radius]
  end

  @spec intersects_rectangle?(t(), Rectangle.t()) :: boolean()
  def intersects_rectangle?(circle, rect) do
    Rectangle.edges(rect)
    |> Enum.any?(fn edge -> intersects_line_segment?(circle, edge) end)
  end

  @spec move(t(), Vector.t()) :: t()
  def move(circle, vec) do
    update_in(circle, [:center], &Vector.add(&1, vec))
  end

  @spec ensure_inside_viewport(t()) :: t()
  def ensure_inside_viewport(circle) do
    update_in(circle, [:center], fn {x, y} ->
      {
        x |> min(Viewport.width() - circle[:radius] / 2) |> max(circle[:radius] / 2),
        y |> min(Viewport.height() - circle[:radius] / 2) |> max(circle[:radius] / 2)
      }
    end)
  end
end
