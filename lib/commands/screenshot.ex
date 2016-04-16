defmodule Selenium.Commands.Screenshot do

  alias Selenium.Session
  alias Selenium.Request

  # Save the screenshot to a file given by path
  def save(identifier, path) do
    %{ "class" => _, "hCode" => _, "sessionId" => _, "state" => _, "status" => _, "value" => png} = take(identifier)

    # Decode the base64 string
    {:ok, png} = Base.decode64(png)
    # And write it to a file
    File.write(path, png)
  end

  # Returns the raw response of the screenshot request
  def take(identifier) do
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.get("session/#{session_id}/screenshot", [], [recv_timeout: Application.get_env(:selenium, :timeout), hackney: [pool: :driver_pool]])
    body
  end
end
