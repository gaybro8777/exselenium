defmodule Selenium.Window do

  alias Selenium.Session

  # Get all the window handles
  def all(identifier) do
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.get("session/#{session_id}/window_handles")

    body["value"]
  end

  # Get the current window handle
  def current(identifier) do
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.get("session/#{session_id}/window_handle")
    body["value"]
  end

  # Maximize the window
  def maximize(handle, identifier) do
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: _,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/window/#{handle}/maximize", "")
    :ok
  end

  # Get the size of the window
  def get_size(handle, identifier) do
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.get("session/#{session_id}/window/#{handle}/size")
    %{ "width" => body["value"]["width"], "height" => body["value"]["height"] }
  end

  # Change the window dimensions
  def resize(handle, identifier, width, height) do
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: _,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/window/#{handle}/size", %{ "width" => width, "height" => height })

    :ok
  end
end
