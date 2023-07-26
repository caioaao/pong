defmodule Pong.Core.PlayerPad do
  alias Pong.Core.{Rectangle, Field}

  @move_delta 5

  @type t() :: %{geometry: Rectangle.t()}

  @spec move_left(t(), Field.t()) :: t()
  def move_left(pad, field) do
    update_in(pad, [:geometry], fn geom ->
      Field.ensure_rectangle_inside_field(field, Rectangle.move(geom, {-@move_delta, 0}))
    end)
  end

  @spec move_right(t(), Field.t()) :: t()
  def move_right(pad, field) do
    update_in(pad, [:geometry], fn geom ->
      Field.ensure_rectangle_inside_field(field, Rectangle.move(geom, {@move_delta, 0}))
    end)
  end
end
