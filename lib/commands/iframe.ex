defmodule Selenium.Commands.Iframe do
  alias Selenium.Session
  alias Selenium.Request

  # Change focus to an iframe
  def focus(identifier, id) do
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/frame", %{"id" => id}, [recv_timeout: :infinity])
    body
  end

  # Change focus to the parent frame
  def parent(identifier) do
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/frame/parent", "", [recv_timeout: :infinity])
    body
  end

end
