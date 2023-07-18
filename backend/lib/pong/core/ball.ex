defmodule Pong.Core.Ball do
  alias Pong.Core.{Circle, Vector}

  @type t() :: %{geometry: Circle.t(), velocity: Vector.t()}

  def speed, do: 60
  def radius, do: 5
  def initial_velocity, do: {0, speed()}
end
