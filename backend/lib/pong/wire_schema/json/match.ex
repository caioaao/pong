defmodule Pong.WireSchema.Json.Match do
  @type xy() :: %{x: number(), y: number()}

  @type ball() :: %{
          geometry: %{center: xy(), radius: number()},
          velocity: xy()
        }

  @type pad() :: %{
          geometry: %{center: xy(), width: number(), height: number()}
        }

  @type score() :: %{player1: number(), player2: number()}

  @type created() :: %{
          state: :created,
          millis_left_until_timeout: number(),
          players_ready: [Player.id()]
        }

  @type starting() :: %{
          state: :starting,
          millis_left_until_start: number()
        }

  @type in_progress() :: %{
          state: :in_progress,
          score: score(),
          field: %{width: number(), height: number()},
          ball: ball(),
          player1_pad: pad(),
          player2_pad: pad()
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

  @spec marshal(Match.state()) :: String.t()
  def marshal(state) do
    with {:ok, payload} <-
           state
           |> reshape_state()
           |> Jason.encode() do
      payload
    end
  end

  @spec reshape_state(Match.state()) :: state()
  defp reshape_state(%{state: :created} = state) do
    Map.update!(state, :players_ready, &MapSet.to_list/1)
  end

  defp reshape_state(%{state: :starting} = state) do
    state
  end

  defp reshape_state(%{state: :in_progress} = state) do
    state
    |> Map.update!(:score, &reshape_score/1)
    |> Map.update!(:ball, &reshape_ball/1)
    |> Map.update!(:field, fn {x, y} -> %{width: x, height: y} end)
    |> Map.update!(:player1_pad, &reshape_geom_center/1)
    |> Map.update!(:player2_pad, &reshape_geom_center/1)
  end

  defp reshape_state(%{state: :paused} = state) do
    Map.update!(state, :prev_state, &reshape_state/1)
  end

  defp reshape_state(%{state: :finished} = state) do
    Map.update!(state, :final_Score, &reshape_score/1)
  end

  @spec reshape_score(Match.score()) :: score()
  defp reshape_score({p1, p2}), do: %{player1: p1, player2: p2}

  @spec reshape_xy({number(), number()}) :: xy()
  defp reshape_xy({x, y}), do: %{x: x, y: y}

  @spec reshape_ball(Ball.t()) :: ball()
  defp reshape_ball(ball) do
    ball
    |> reshape_geom_center()
    |> Map.update!(:velocity, &reshape_xy/1)
  end

  @spec reshape_geom_center(%{geometry: %{center: Point.t()}}) :: pad()
  defp reshape_geom_center(obj) do
    update_in(obj, [:geometry, :center], &reshape_xy/1)
  end
end
