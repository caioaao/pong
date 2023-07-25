defmodule Pong.Api.Http.Router do
  use Plug.Router

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  alias Pong.Core.Match.Registry.V2, as: MatchRegistry

  plug(:match)
  plug(:cors)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    json_decoder: Jason
  )

  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Ok")
  end

  get "/matches/:match_id/players" do
    case MatchRegistry.lookup(match_id) do
      {:ok, {_, _, %{player1: player1, player2: player2}}} ->
        {:ok, res_body} = Jason.encode(%{player1: player1, player2: player2})

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, res_body)

      {:error, :match_not_found} ->
        send_resp(conn, 404, "Not Found")
    end
  end

  post "/matches" do
    case conn.body_params do
      %{"player1" => player1, "player2" => player2} ->
        {match_id, _, _} = MatchRegistry.start_match(player1: player1, player2: player2)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, ~s({"match_id":"#{match_id}"}))

      _ ->
        send_resp(conn, 400, "Bad Request")
    end
  end

  options _ do
    send_resp(conn, 200, "")
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end

  def cors(conn, _) do
    conn
    |> put_resp_header("Access-Control-Allow-Origin", "*")
    |> put_resp_header("Access-Control-Allow-Methods", "*")
    |> put_resp_header("Access-Control-Allow-Headers", "*")
  end
end
