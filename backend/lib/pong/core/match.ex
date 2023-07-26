defmodule Pong.Core.Match do
  alias Pong.Core.{Player, Ball, PlayerPad, Field, Circle}

  @type id() :: String.t()

  @type score() :: {number(), number()}

  @type created() :: %{
          state: :created,
          millis_left_until_timeout: number(),
          players_ready: MapSet.t(Player.id())
        }

  @type starting() :: %{
          state: :starting,
          millis_left_until_start: number()
        }

  @type in_progress() :: %{
          state: :in_progress,
          score: score(),
          field: Field.t(),
          ball: Ball.t(),
          player1_pad: PlayerPad.t(),
          player2_pad: PlayerPad.t()
        }

  @type paused() :: %{
          state: :paused,
          prev_state: in_progress()
        }

  @type finished() :: %{
          state: :finished,
          winner: Player.id(),
          final_score: score()
        }

  @type canceled() :: %{state: :canceled}

  @type state() :: created() | starting() | in_progress() | finished() | canceled()

  @match_id_chars "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

  @spec gen_id() :: Match.id()
  @spec gen_id(integer()) :: Match.it()

  def gen_id(len \\ 8) do
    Stream.repeatedly(fn -> :rand.uniform(String.length(@match_id_chars)) - 1 end)
    |> Enum.take(len)
    |> Enum.map(&String.at(@match_id_chars, &1))
    |> List.to_string()
  end

  @spec create() :: created()
  def create(millis_until_timeout \\ 60_000) do
    %{
      state: :created,
      millis_left_until_timeout: millis_until_timeout,
      players_ready: MapSet.new()
    }
  end

  @spec start() :: in_progress()
  def start() do
    %{
      state: :in_progress,
      ball: %{
        geometry: %{radius: Ball.radius(), center: {50, 50}},
        velocity: Ball.initial_velocity()
      },
      field: {100, 100},
      player1_pad: %{geometry: %{center: {50, 10}, width: 20, height: 2}},
      player2_pad: %{geometry: %{center: {50, 90}, width: 20, height: 2}},
      score: {0, 0}
    }
  end

  @spec record_point(Match.in_progress(), Player.id()) :: Match.in_progress() | Match.finished()
  def record_point(match, player) do
    match
    |> Map.update!(:score, fn {p1, p2} ->
      case player do
        :player1 -> {p1 + 1, p2}
        :player2 -> {p1, p2 + 1}
      end
    end)
    |> reset_ball()
    |> case do
      state = %{score: {p1, _}} when p1 >= 11 ->
        %{state: :finished, winner: :player1, final_score: state[:score]}

      state = %{score: {_, p2}} when p2 >= 11 ->
        %{state: :finished, winner: :player2, final_score: state[:score]}

      new_state ->
        new_state
    end
  end

  @spec reset_ball(Match.in_progress()) :: Match.in_progress()
  def reset_ball(state) do
    state
    |> Map.update!(:ball, fn ball ->
      ball
      |> Map.update!(:geometry, &Map.put(&1, :center, Field.center(state[:field])))
      |> Map.put(:velocity, Ball.initial_velocity())
    end)
  end

  @spec ball_collision(%{
          ball: Ball.t(),
          field: Field.t(),
          player1_pad: PlayerPad.t(),
          player2_pad: PlayerPad.t()
        }) ::
          :left_wall | :right_wall | :player1_pad | :player2_pad | :bottom_wall | :top_wall | nil
  def ball_collision(%{
        ball: ball,
        field: field,
        player1_pad: player1_pad,
        player2_pad: player2_pad
      }) do
    cond do
      Circle.intersects_line_segment?(ball[:geometry], Field.top_edge(field)) ->
        :top_wall

      Circle.intersects_line_segment?(ball[:geometry], Field.bottom_edge(field)) ->
        :bottom_wall

      Circle.intersects_line_segment?(ball[:geometry], Field.left_edge(field)) ->
        :left_wall

      Circle.intersects_line_segment?(ball[:geometry], Field.right_edge(field)) ->
        :right_wall

      Circle.intersects_rectangle?(ball[:geometry], player1_pad[:geometry]) ->
        :player1_pad

      Circle.intersects_rectangle?(ball[:geometry], player2_pad[:geometry]) ->
        :player2_pad

      :default ->
        nil
    end
  end

  @spec pause(in_progress()) :: paused()
  def pause(state) do
    %{state: :paused, prev_state: state}
  end

  @spec unpause(paused()) :: in_progress()
  def unpause(state) do
    state[:prev_state]
  end

  @spec move_player_pad(in_progress(), Player.id(), :left | :right) :: in_progress()
  def move_player_pad(state, player_id, direction) do
    pad_key =
      case player_id do
        :player1 -> :player1_pad
        :player2 -> :player2_pad
      end

    case direction do
      :left -> Map.update!(state, pad_key, &PlayerPad.move_left(&1, state[:field]))
      :right -> Map.update!(state, pad_key, &PlayerPad.move_right(&1, state[:field]))
    end
  end
end
