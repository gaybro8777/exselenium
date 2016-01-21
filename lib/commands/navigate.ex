defmodule Selenium.Commands.Navigate do

  alias Selenium.Session
  alias Selenium.Request

  # Get the current URL for a session
  def current(identifier) do
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.get("session/#{session_id}/url", [recv_timeout: :infinity])
    body["value"]
  end

  # Navigate to another url
  def to(identifier, url) do
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/url", %{ "url" => url}, [recv_timeout: :infinity])
    body["value"]
  end

  def forward(identifier) do
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/forward", "", [recv_timeout: :infinity])
    body["value"]
  end

  def back(identifier) do
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/back", "", [recv_timeout: :infinity])
    body["value"]
  end

  def refresh(identifier) do
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/refresh", "", [recv_timeout: :infinity])
    body["value"]
  end

end
