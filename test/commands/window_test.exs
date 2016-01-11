defmodule WindowTest do
  use ExUnit.Case
  alias Selenium.Session
  alias Selenium.Window

  doctest Window

  test "get all window handles" do
    session_name = "window all handles"

    # Create a new session
    Session.create(session_name, "firefox")

    # Get all the window handles
    handles = Window.all(session_name)

    # Close the window
    Session.destroy(session_name)

    # There should only be one handle
    assert length(handles) == 1

  end

  test "get one handle" do
    session_name = "window single handles"

    # Create a new session
    Session.create(session_name, "firefox")

    # Get all the window handles
    handle = Window.current(session_name)

    # Close the window
    Session.destroy(session_name)

    # The handle is random but we do know it's another UUID with opening and closing { }
    assert Regex.match?(~r/^\{[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}\}$/, handle)

  end

  test "maximize window" do

    session_name = "window maximize"

    # Create a new session
    Session.create(session_name, "firefox")

    # Maximize current window
    status = Window.current(session_name) |> Window.maximize(session_name)
    assert status == :ok

    # Close the window
    Session.destroy(session_name)

  end

  test "resize window" do
    session_name = "window resize"

    # Create a new session
    Session.create(session_name, "firefox")

    # Set the window size to 1024 by 768
    status = Window.current(session_name) |> Window.resize(session_name, 1024, 768)
    assert status == :ok

    # Close the window
    Session.destroy(session_name)

  end

  test "get window size" do
    session_name = "window get size"

    # Create a new session
    Session.create(session_name, "firefox")

    # Set the window size
    status = Window.current(session_name) |> Window.resize(session_name, 800, 600)
    assert status == :ok

    window_size = Window.current(session_name) |> Window.get_size(session_name)
    assert window_size == %{ "height" => 600, "width" => 800}

    # Close the window
    Session.destroy(session_name)

  end

end
