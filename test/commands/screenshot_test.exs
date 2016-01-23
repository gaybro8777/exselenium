defmodule ScreenshotTest do
  use ExUnit.Case
  alias Selenium.Session
  alias Selenium.Commands.Navigate
  alias Selenium.Commands.Screenshot

  doctest Screenshot

  test "saving a screenshot should result in a file being saved" do
    session_name = "screenshot save"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facebook
    Navigate.to(session_name, "https://www.facebook.com")

    result = Screenshot.take(session_name)

    # Close the window
    Session.destroy(session_name)

  end

  test "taking a raw screenshot should output a raw png" do

    session_name = "screenshot raw"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facebook
    Navigate.to(session_name, "https://www.facebook.com")

    result = Screenshot.save(session_name, "./test.png")

    # Close the window
    Session.destroy(session_name)

    # The screenshot should return ok
    assert result == :ok

    # And the file should exist
    assert File.exists?("./test.png")

    # Remove the file
    File.rm("./test.png")

  end

end
