defmodule MouseTest do
  use ExUnit.Case

  alias Selenium.Session
  alias Selenium.Commands.Navigate
  alias Selenium.Commands.Mouse

  doctest Mouse

  test "executing javascript syncronously" do
    session_name = "javascript execute"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facebook
    Navigate.to(session_name, "https://www.facebook.com")

    # Run some javascript
    value = Javascript.execute(session_name, "function(test) { return test; }", ["swag"]);

    # Close the window
    Session.destroy(session_name)

    assert value == "swag"
  end

  test "executing javascript asyncronously" do
    session_name = "javascript execute async"

    # Create a new session
    Session.create(session_name, "firefox")

    # Set the wait time
    Javascript.async_wait(session_name, 10000)

    # Go to facebook
    Navigate.to(session_name, "https://www.facebook.com")

    # Run some javascript asyncronously
    value = Javascript.execute_async(session_name, "function(test, done) { setTimeout(function() { done(test === 'swag'); }, 1000); }", ["swag"]);

    # Close the window
    Session.destroy(session_name)

    assert value == true
  end
end
