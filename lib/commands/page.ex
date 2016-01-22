defmodule Selenium.Commands.Page do
  alias Selenium.Session
  alias Selenium.Request

  # Get the page source
  def source(identifier) do
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.get("session/#{session_id}/source", [recv_timeout: :infinity])
    body["value"]
  end

  # Get the page title
  def title(identifier) do
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.get("session/#{session_id}/title", [recv_timeout: :infinity])
    body["value"]
  end

  # Get the orientation of the browser
  def orientation(identifier) do
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.get("session/#{session_id}/orientation", [recv_timeout: :infinity])
    body["value"]
  end

  # Set the screen orientation
  def orientation(identifier, orientation) do
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/orientation", %{"orientation" => orientation}, [recv_timeout: :infinity])
    body["value"]
  end

end
