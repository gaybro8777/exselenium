defmodule AlertTest do
  use ExUnit.Case
  alias Selenium.Session
  alias Selenium.Commands.Navigate
  alias Selenium.Commands.Javascript
  alias Selenium.Commands.Alert

  doctest Alert

  test "get alert text" do
    session_name = "alert text"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to google
    Navigate.to(session_name, "https://www.google.com")

    # Check that the current page is google.com
    Navigate.current(session_name)

    Javascript.execute(session_name, """
    function() {
      alert('Test');
    }
    """, [])

    assert Alert.text(session_name) == "Test"

    # Close the window
    Session.destroy(session_name)

  end

  test "set alert text" do
    session_name = "alert text set"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to google
    Navigate.to(session_name, "https://www.google.com")

    # Check that the current page is google.com
    Navigate.current(session_name)

    Javascript.execute(session_name, """
    function() {
      prompt('Testing');
    }
    """, [])

    assert Alert.text(session_name, "This enters the text")
    assert Alert.text(session_name) == "Testing"
    assert Alert.accept(session_name)

    # Close the window
    Session.destroy(session_name)

  end

  test "dismissing alert" do
    session_name = "alert dismiss"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to google
    Navigate.to(session_name, "https://www.google.com")

    # Check that the current page is google.com
    Navigate.current(session_name)

    Javascript.execute(session_name, """
    function() {
      alert('Testing');
    }
    """, [])

    assert Alert.dismiss(session_name)

    # Close the window
    Session.destroy(session_name)

  end

end
