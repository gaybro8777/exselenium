defmodule Selenium.Commands.SessionStorage do

  alias Selenium.Session
  alias Selenium.Request

  # Get the entire local storage
  def all(identifier) do
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.get("session/#{session_id}/session_storage", [recv_timeout: :infinity])
    body["value"]
  end

  # Get a single session storage element by key
  def get(identifier, key) do
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.get("session/#{session_id}/session_storage/key/#{key}", [recv_timeout: :infinity])
    body["value"]
  end

  # Delete a session storage item by key
  def remove_item(identifier, key) do
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.delete("session/#{session_id}/session_storage/key/#{key}", [recv_timeout: :infinity])
    body["value"]
  end

  # Set a new session storage variable
  def set(identifier, key, value) do
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/session_storage", %{ "key" => key, "value" => value }, [recv_timeout: :infinity])
    body["value"]
  end

  # Clear the session storage object
  def clear(identifier) do
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.delete("session/#{session_id}/session_storage", [recv_timeout: :infinity])
    body["value"]
  end

  # Get the session storage size
  def size(identifier) do
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.get("session/#{session_id}/session_storage/size", [recv_timeout: :infinity])
    body["value"]
  end
end
