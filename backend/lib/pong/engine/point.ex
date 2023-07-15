defmodule Pong.Engine.Point do
  alias Pong.Engine.{Vector}

  @type t() :: {number(), number()}

  @spec translate(t(), Vector.t()) :: t()
  def translate(point, vec) do
    Vector.add(point, vec)
  end
end
