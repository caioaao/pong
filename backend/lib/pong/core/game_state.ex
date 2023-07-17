defmodule Pong.Core.GameState do
  alias Pong.Core.{Circle, PlayerPad}

  @type t() :: %{
          ball: %{geometry: Circle.t(), velocity: Pong.Core.Vector.t()},
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
      ball: %{geometry: %{radius: 5, center: {50, 50}}, velocity: {0, 0}},
      player1_pad: %{geometry: %{center: {50, 10}, width: 20, height: 2}},
      player2_pad: %{geometry: %{center: {50, 90}, width: 20, height: 2}},
      score: {0, 0},
      paused?: false
    }
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
