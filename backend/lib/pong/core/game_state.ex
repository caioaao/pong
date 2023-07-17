defmodule Pong.Core.GameState do
  alias Pong.Core.{Circle, PlayerPad, Vector, Viewport, Ball}

  @type t() :: %{
          ball: Ball.t(),
          player1_pad: PlayerPad.t(),
          player2_pad: PlayerPad.t(),
          score: {integer(), integer()},
          paused?: boolean()
        }

  defmodule Command do
    @type type() :: :move_left | :move_right | :pause | :unpause
    @type actor() :: :player1 | :player2
    @type t() :: {type(), actor()}
  end

  @spec new() :: t()
  def new() do
    %{
      ball: %{
        geometry: %{radius: Ball.radius(), center: {50, 50}},
        velocity: Ball.initial_velocity()
      },
      player1_pad: %{geometry: %{center: {50, 10}, width: 20, height: 2}},
      player2_pad: %{geometry: %{center: {50, 90}, width: 20, height: 2}},
      score: {0, 0},
      paused?: false
    }
  end

  @spec update(t(), number()) :: t()
  def update(game = %{paused?: true}, _) do
    game
  end

  def update(
        game = %{paused?: false, ball: ball, player1_pad: player1_pad, player2_pad: player2_pad},
        ellapsed_millis
      ) do
    delta = Vector.scale(ball[:velocity], ellapsed_millis / 1000)
    ball = update_in(ball, [:geometry], &Circle.move(&1, delta))

    cond do
      Circle.intersects_line_segment?(ball[:geometry], Viewport.bottom_edge()) ->
        update_in(game, [:score], fn {p1, p2} -> {p1, p2 + 1} end)
        |> reset_ball()

      Circle.intersects_line_segment?(ball[:geometry], Viewport.top_edge()) ->
        update_in(game, [:score], fn {p1, p2} -> {p1 + 1, p2} end)
        |> reset_ball()

      Circle.intersects_line_segment?(ball[:geometry], Viewport.left_edge()) or
          Circle.intersects_line_segment?(ball[:geometry], Viewport.right_edge()) ->
        ball =
          ball
          |> update_in([:velocity], fn {x, y} -> {-x, y} end)
          |> update_in([:geometry], &Circle.ensure_inside_viewport/1)

        Map.put(game, :ball, ball)

      Circle.intersects_rectangle?(ball[:geometry], player1_pad[:geometry]) ->
        new_vel =
          Vector.sub(ball[:geometry][:center], player1_pad[:geometry][:center])
          |> Vector.direction()
          |> Vector.scale(Ball.speed())

        ball = Map.put(ball, :velocity, new_vel)

        Map.put(game, :ball, ball)

      Circle.intersects_rectangle?(ball[:geometry], player2_pad[:geometry]) ->
        new_vel =
          Vector.sub(ball[:geometry][:center], player2_pad[:geometry][:center])
          |> Vector.direction()
          |> Vector.scale(Ball.speed())

        ball = Map.put(ball, :velocity, new_vel)

        Map.put(game, :ball, ball)

      true ->
        Map.put(game, :ball, ball)
    end
  end

  defp reset_ball(game) do
    Map.put(game, :ball, %{
      geometry: %{radius: 5, center: {50, 50}},
      velocity: Ball.initial_velocity()
    })
  end

  @spec process_command(t(), Command.t()) :: t()

  def process_command(game = %{paused?: true}, {:move_left, _}) do
    game
  end

  def process_command(game = %{paused?: true}, {:move_right, _}) do
    game
  end

  def process_command(game = %{paused?: false}, {:move_left, :player1}) do
    update_in(game, [:player1_pad], &PlayerPad.move_left/1)
  end

  def process_command(game = %{paused?: false}, {:move_right, :player1}) do
    update_in(game, [:player1_pad], &PlayerPad.move_right/1)
  end

  def process_command(game = %{paused?: false}, {:move_left, :player2}) do
    update_in(game, [:player2_pad], &PlayerPad.move_left/1)
  end

  def process_command(game = %{paused?: false}, {:move_right, :player2}) do
    update_in(game, [:player2_pad], &PlayerPad.move_right/1)
  end

  def process_command(game, {:pause, _}) do
    Map.put(game, :paused?, true)
  end

  def process_command(game, {:unpause, _}) do
    Map.put(game, :paused?, false)
  end
end
