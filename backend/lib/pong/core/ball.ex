defmodule Pong.Core.Ball do
  alias Pong.Core.{Circle, Vector}

  @type t() :: %{geometry: Circle.t(), velocity: Vector.t()}
end
