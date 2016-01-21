defmodule NavigateTest do
  use ExUnit.Case
  alias Selenium.Session
  alias Selenium.Commands.Navigate

  doctest Navigate

  test "navigation to a url should work" do
    session_name = "navigate to"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to google
    Navigate.to(session_name, "https://www.google.com")

    # Check that the current page is google.com
    url = Navigate.current(session_name)

    # Close the window
    Session.destroy(session_name)

    # Current url should equal google
    assert url == "https://www.google.com/"
  end

  test "refreshing a page should result in the same page" do

    session_name = "navigate refresh"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to google
    Navigate.to(session_name, "https://www.facebook.com")

    # Check that the current page is google.com
    Navigate.current(session_name)

    # Refresh the page
    Navigate.refresh(session_name)

    url = Navigate.current(session_name)

    # Close the window
    Session.destroy(session_name)

    # Current url should equal google
    assert url == "https://www.facebook.com/"

  end

  test "navigate going back and forth" do

    session_name = "navigate refresh"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facbeook
    Navigate.to(session_name, "https://www.facebook.com")

    # Go to google
    Navigate.to(session_name, "https://www.google.com/")

    # Go back to facebook
    Navigate.back(session_name)

    # Go forward to google
    Navigate.forward(session_name)

    url = Navigate.current(session_name)

    # Close the window
    Session.destroy(session_name)

    # Current url should be facebook
    assert url == "https://www.google.com/"

  end

end
