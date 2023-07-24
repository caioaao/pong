defmodule Pong.Api.Http.Router do
  use Plug.Router

  alias Pong.Core.Match.Registry.V2, as: MatchRegistry

  plug(Plug.Static,
    at: "/",
    from: :backend_app
  )

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Ok")
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

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
