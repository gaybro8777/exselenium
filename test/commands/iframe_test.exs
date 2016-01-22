defmodule IframeTest do
  use ExUnit.Case

  alias Selenium.Session
  alias Selenium.Commands.Navigate
  alias Selenium.Commands.Iframe
  alias Selenium.Commands.Page

  doctest Iframe

  test "focusing iframe and unfocusing an iframe" do

    session_name = "iframe focus"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to a page with an iframe
    Navigate.to(session_name, "http://www.littlewebhut.com/articles/html_iframe_example/")

    # Focus on the iframe
    Iframe.focus(session_name, "imgbox")

    source = Page.source(session_name)

    # Go to the parent frame
    Iframe.parent(session_name)

    original_title = Page.title(session_name)

    # Close the window
    Session.destroy(session_name)

    assert source == "<html xmlns=\"http://www.w3.org/1999/xhtml\"><head><meta name=\"viewport\" content=\"width=device-width; height=device-height;\" /><link rel=\"stylesheet\" href=\"resource://gre/res/ImageDocument.css\" /><title>eightball.gif (GIF Image, 100 × 168 pixels)</title></head><body><img src=\"http://www.littlewebhut.com/images/eightball.gif\" alt=\"http://www.littlewebhut.com/images/eightball.gif\" /></body></html>"

    assert original_title == "HTML iframe Example"

  end

end
