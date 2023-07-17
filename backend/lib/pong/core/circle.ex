defmodule Pong.Core.Circle do
  alias Pong.Core.{Point, LineSegment, Rectangle}

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
end
