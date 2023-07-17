defmodule Pong.Core.Viewport do
  def width, do: 100
  def height, do: 100
  def left_edge, do: {{0, 0}, {0, height()}}
  def right_edge, do: {{width(), 0}, {width(), height()}}
  def top_edge, do: {{0, height()}, {width(), height()}}
  def bottom_edge, do: {{0, 0}, {width(), 0}}
end
