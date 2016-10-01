defmodule TestServer do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _) do
    conn
    |> put_resp_content_type("text/html")
    send_resp(conn, 200, """
    <html>
      <head>
        <title> The simplest HTML example</title>
      </head>
      <body>
        <h1 class="nospellingerrors"> This is an HTML Page.</h1>
        <h1 class="spellingerrors"> This iz an HTML Page.</h1>

        <a href="/">Home</a>
        <a href="/back">Back</a>
        <a href="http://localhost:9191">Bad URL</a>

        <div class="attributetest" extra="goodvalue">Testing attributes</div>

        <div class="elementtest">Testing all the html contents<b>INCLUDING</b> the inner stuff<span>like span tags</span></div>
      </body>
    </html>
    """)
  end
end

defmodule TestAuthServer do
  import Plug.Conn
  use Plug.Router

  plug PlugBasicAuth, validation: &TestAuthServer.is_authorized/2
  plug :match
  plug :dispatch

  get "/" do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, """
    <html>
      <head>
        <title>The simplest HTML example</title>
      </head>
      <body>
        <input type="text" id="setvaluetest" />
        <button id="testbutton">Test</button>
      </body>
    </html>
    """)
  end

  match _ do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Everything else")
  end

  def is_authorized("testusername", "testpassword"), do: :authorized
  def is_authorized(_user, _password), do: :unauthorized
end

ExUnit.start()
