defmodule Selenium.Commands.Alert do

  alias Selenium.Session
  alias Selenium.Request

  # Gets the text of an alert/promt/confirm dialog
  def text(identifier) do
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.get("session/#{session_id}/alert_text", [], [recv_timeout: :infinity, hackney: [pool: :driver_pool]])
    body["value"]
  end

  # Sends keystrokes to a prompt dialog
  def text(identifier, text) do
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/alert_text", %{ "text" => text}, [], [recv_timeout: :infinity, hackney: [pool: :driver_pool]])
    body["state"] == "success"
  end

  # Accepts an alert dialog
  def accept(identifier) do
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/accept_alert", "", [], [recv_timeout: :infinity, hackney: [pool: :driver_pool]])
    body["state"] == "success"
  end

  # Dismisses an alert dialog
  def dismiss(identifier) do
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/dismiss_alert", "", [], [recv_timeout: :infinity, hackney: [pool: :driver_pool]])
    body["state"] == "success"
  end

end
