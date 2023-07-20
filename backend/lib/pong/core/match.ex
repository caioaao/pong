defmodule Pong.Core.Match do
  @match_id_chars "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

  def gen_match_id(len \\ 8) do
    Stream.repeatedly(fn -> :rand.uniform(String.length(@match_id_chars)) - 1 end)
    |> Enum.take(len)
    |> Enum.map(&String.at(@match_id_chars, &1))
    |> List.to_string()
  end
end
