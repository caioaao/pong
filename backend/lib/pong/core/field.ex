defmodule Pong.Core.Field do
  alias Pong.Core.{LineSegment, Point}

  def default_width, do: 100
  def default_height, do: 100

  @typedoc """
  tuple of {width, height}
  """
  @type t() :: {number(), number()}

  @spec left_edge(t()) :: LineSegment.t()
  def left_edge({_, height}) do
    {{0, 0}, {0, height}}
  end

  @spec right_edge(t()) :: LineSegment.t()
  def right_edge({width, height}) do
    {{width, 0}, {width, height}}
  end

  @spec top_edge(t()) :: LineSegment.t()
  def top_edge({width, height}) do
    {{0, height}, {width, height}}
  end

  @spec bottom_edge(t()) :: LineSegment.t()
  def bottom_edge({width, _}) do
    {{0, 0}, {width, 0}}
  end

  @spec center_x(t()) :: number()
  def center_x({width, _}) do
    width / 2
  end

  @spec center_y(t()) :: number()
  def center_y({_, height}) do
    height / 2
  end

  @spec center(t()) :: Point.t()
  def center(field) do
    {center_x(field), center_y(field)}
  end

  @spec ensure_rectangle_inside_field(t(), Rectangle.t()) :: Rectangle.t()
  def ensure_rectangle_inside_field({width, height}, rect) do
    update_in(rect, [:center], fn {x, y} ->
      {
        x |> min(width - rect[:width] / 2) |> max(rect[:width] / 2),
        y |> min(height - rect[:height] / 2) |> max(rect[:height] / 2)
      }
    end)
  end

  @spec ensure_circle_inside_field(t(), Circle.t()) :: Circle.t()
  def ensure_circle_inside_field({width, height}, circle) do
    update_in(circle, [:center], fn {x, y} ->
      {
        x |> min(width - circle[:radius]) |> max(circle[:radius]),
        y |> min(height - circle[:radius]) |> max(circle[:radius])
      }
    end)
  end
end
