defmodule Selenium.Commands.Location do

  alias Selenium.Session
  alias Selenium.Request

  # Get the current geo location
  def current(identifier) do
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.get("session/#{session_id}/location", [], [recv_timeout: Application.get_env(:selenium, :timeout), hackney: [pool: :driver_pool]])
    body["value"]
  end

  # Set the geo location
  def set(identifier, lat, long, alt) do
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/location", %{ "latitude" => lat, "longitude" => long, "altitude" => alt }, [], [recv_timeout: Application.get_env(:selenium, :timeout), hackney: [pool: :driver_pool]])
    body["value"]
  end

end
