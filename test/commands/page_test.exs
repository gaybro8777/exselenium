defmodule PageTest do
  use ExUnit.Case

  alias Selenium.Session
  alias Selenium.Commands.Navigate
  alias Selenium.Commands.Page

  doctest Page

  test "getting page title" do
    session_name = "page title"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facebook
    Navigate.to(session_name, "https://www.facebook.com")

    # Get the page title
    value = Page.title(session_name)

    # Close the window
    Session.destroy(session_name)

    assert value == "Facebook - Log In or Sign Up"
  end

  test "getting page source" do
    session_name = "page source"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to about:blank which is a blank html file
    Navigate.to(session_name, "about:blank")

    # Get the page source
    source = Page.source(session_name)

    # Close the window
    Session.destroy(session_name)

    assert source == "<html xmlns=\"http://www.w3.org/1999/xhtml\"><head></head><body></body></html>"
  end
end
