defmodule Selenium.Commands.Window do

  alias Selenium.Session
  alias Selenium.Request

  # Get all the window handles
  def all(identifier) do
    HTTPoison.start()
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.get("session/#{session_id}/window_handles", [recv_timeout: :infinity])

    body["value"]
  end

  # Get the current window handle
  def current(identifier) do
    HTTPoison.start()
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.get("session/#{session_id}/window_handle", [recv_timeout: :infinity])
    body["value"]
  end

  # Maximize the window
  def maximize(handle, identifier) do
    HTTPoison.start()
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: _,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/window/#{handle}/maximize", "", [recv_timeout: :infinity])
    :ok
  end

  # Get the size of the window
  def get_size(handle, identifier) do
    HTTPoison.start()
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.get("session/#{session_id}/window/#{handle}/size", [recv_timeout: :infinity])
    %{ "width" => body["value"]["width"], "height" => body["value"]["height"] }
  end

  # Change the window dimensions
  def resize(handle, identifier, width, height) do
    HTTPoison.start()
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: _,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/window/#{handle}/size", %{ "width" => width, "height" => height }, [recv_timeout: :infinity])

    :ok
  end
end
