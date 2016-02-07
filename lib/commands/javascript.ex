defmodule Selenium.Commands.Javascript do
  alias Selenium.Session
  alias Selenium.Request

  defp transform(script) do
    # Transform the function so they don't have to reference variables with "arguments"
    "return (#{script}).apply(null, arguments);"
  end

  # Executes javascript and returns a value
  def execute(identifier, function, args \\ []) do
    HTTPoison.start()
    session_id = Session.get(identifier)

    # Turn the function into an actual function
    function = transform(function)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/execute", %{"script" => function, "args" => args}, [recv_timeout: :infinity])
    body["value"]
  end

  # Executes javascript asyncronously, does not wait for return
  def execute_async(identifier, function, args \\ []) do
    HTTPoison.start()
    session_id = Session.get(identifier)

    # Turn the function into an actual function
    function = transform(function)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/execute_async", %{"script" => function, "args" => args}, [recv_timeout: :infinity])
    body["value"]
  end

  # Sets the amount of time we'll wait for an async script to return, in ms
  def async_wait(identifier, time) do
    HTTPoison.start()
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/timeouts/async_script", %{"ms" => time}, [recv_timeout: :infinity])
    body
  end
end
