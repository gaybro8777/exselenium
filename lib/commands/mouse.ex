defmodule Selenium.Commands.Mouse do
  alias Selenium.Session
  alias Selenium.Request

  @mouse_button %{"left" => 0, "middle" => 1, "right" => 2}

  # Moves the mouse to a new %Selenium.Position{}, can be relative to another
  # element or relative to the current mouse position
  def move_to(identifier, position, element \\ nil) do
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/moveto", %{"xoffset" => position.x, "yoffset" => position.y, "element" => element}, [], [recv_timeout: :infinity, hackney: [pool: :driver_pool]])
    body["value"]
  end

  # Clicks at the current mouse position with the given
  # mouse button
  # left, middle, or right
  def click(identifier, button) do
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/click", %{"button" => @mouse_button[button]}, [], [recv_timeout: :infinity, hackney: [pool: :driver_pool]])
    body["value"]
  end

  # Holds the given mouse button down until button up is called
  def button_down(identifier, button) do
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/buttondown", %{"button" => @mouse_button[button]}, [], [recv_timeout: :infinity, hackney: [pool: :driver_pool]])
    body["value"]
  end

  # Releases the button that was previously down
  def button_up(identifier, button) do
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/buttonup", %{"button" => @mouse_button[button]}, [], [recv_timeout: :infinity, hackney: [pool: :driver_pool]])
    body["value"]
  end

  # Double clicks
  def double_click(identifier, button) do
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/doubleclick", %{"button" => @mouse_button[button]}, [], [recv_timeout: :infinity, hackney: [pool: :driver_pool]])
    body["value"]
  end
end
