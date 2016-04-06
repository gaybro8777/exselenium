defmodule Selenium.Commands.Touch do
  alias Selenium.Session
  alias Selenium.Request

  # Taps on an element (id)
  def tap(identifier, element) do
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/touch/click", %{ "element" => element }, [], [recv_timeout: :infinity, hackney: [pool: :driver_pool]])
    body["value"]
  end

  # Holds the tap event at an x/y position
  def hold(identifier, position) do
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/touch/down", %{"x" => position.x, "y" => position.y}, [], [recv_timeout: :infinity, hackney: [pool: :driver_pool]])
    body["value"]
  end

  # Releases the long press
  def release(identifier, position) do
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/touch/up", %{"x" => position.x, "y" => position.y}, [], [recv_timeout: :infinity, hackney: [pool: :driver_pool]])
    body["value"]
  end

  # Moves finger to a new location, useful for drag events
  def move(identifier, position) do
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/touch/move", %{"x" => position.x, "y" => position.y}, [], [recv_timeout: :infinity, hackney: [pool: :driver_pool]])
    body["value"]
  end

  # Starts touch scroll from an element
  def scroll(identifier, position, element) do
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/touch/scroll", %{"xoffset" => position.x, "yoffset" => position.y, "element" => element}, [], [recv_timeout: :infinity, hackney: [pool: :driver_pool]])
    body["value"]
  end

  # Starts scroll from current position
  def scroll(identifier, position) do
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/touch/move", %{"xoffset" => position.x, "yoffset" => position.y}, [], [recv_timeout: :infinity, hackney: [pool: :driver_pool]])
    body["value"]
  end

  # Double taps an element
  def double_tap(identifier, element) do
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/touch/doubleclick", %{"element" => element}, [], [recv_timeout: :infinity, hackney: [pool: :driver_pool]])
    body["value"]
  end

  # Long presses an element
  def long_press(identifier, element) do
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/touch/longclick", %{"element" => element}, [], [recv_timeout: :infinity, hackney: [pool: :driver_pool]])
    body["value"]
  end

  # Flick gesture starting at element and going to another location.
  # Speed is in pixels per second
  def flick(identifier, position, speed, element) do
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/touch/flick", %{"element" => element, "speed" => speed, "xoffset" => position.x, "yoffset" => position.y}, [], [recv_timeout: :infinity, hackney: [pool: :driver_pool]])
    body["value"]
  end

  # Flick gesture in x and y speed if you don't care which element to start at
  def flick(identifier, xspeed, yspeed) do
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/touch/flick", %{"xspeed" => xspeed, "yspeed" => yspeed}, [], [recv_timeout: :infinity, hackney: [pool: :driver_pool]])
    body["value"]
  end
end
