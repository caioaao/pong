defmodule Backend.Http.Router do
  use Plug.Router

  plug(Plug.Static,
    at: "/",
    from: :backend_app
  )

  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Ok")
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
