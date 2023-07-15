defmodule Backend.Engine.Point do
  alias Backend.Engine.{Vector}

  @type t() :: {number(), number()}

  @spec translate(t(), Vector.t()) :: t()
  def translate(point, vec) do
    Vector.add(point, vec)
  end
end
