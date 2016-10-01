defmodule CookieTest do
  use ExUnit.Case, async: true

  alias Selenium.Session
  alias Selenium.Commands.Navigate
  alias Selenium.Commands.Cookie

  doctest Cookie

	setup_all do

		IO.puts "Booting test server"
		Plug.Adapters.Cowboy.http(TestServer, %{})

		# No metadata
		:ok
	end

  test "getting all the cookies" do
    session_name = "cookie all"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to local site
    Navigate.to(session_name, "http://localhost:4000")

		# Set the test cookie
		Cookie.set(session_name, %Cookie{name: "test", value: "cookiemonster"})
		Cookie.set(session_name, %Cookie{name: "testcookie", value: "cookiemonster"})

    # Grab all the cookies
    cookies = Cookie.all(session_name)

    # Close the window
    Session.destroy(session_name)

    # There should be two cookies
    assert length(cookies) == 2

    # Each of the cookies should be a cookie struct
    Enum.each cookies, fn(cookie) ->
      assert cookie.__struct__ == Selenium.Commands.Cookie
    end

  end

  test "getting one cookie" do
    session_name = "cookie get"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to test site
    Navigate.to(session_name, "http://localhost:4000")

		# Set the test cookie
		Cookie.set(session_name, %Cookie{name: "testcookie", value: "cookiemonster"}) 

    # Grab a single cookie
    good_cookie = Cookie.get(session_name, "testcookie")
    bad_cookie = Cookie.get(session_name, "does not exist")

    # Close the window
    Session.destroy(session_name)

    # Good cookie should exist, bad cookie should not
    assert is_nil(bad_cookie)
    refute is_nil(good_cookie)

  end

  test "setting a cookie" do
    session_name = "cookie set"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facebook
    Navigate.to(session_name, "http://localhost:4000")

    # Create a new cookie
    cookie = %Cookie{name: "selenium", value: "is the best"}
    # Set it
    Cookie.set(session_name, cookie)

    # Get it back from selenium
    retrieved_cookie = Cookie.get(session_name, "selenium")

    # Close the window
    Session.destroy(session_name)

    assert retrieved_cookie.name == "selenium"
    assert retrieved_cookie.value == "is the best"

  end

  test "deleting all the cookies" do
    session_name = "cookie delete all"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to site
    Navigate.to(session_name, "http://localhost:4000")

    # Create a new cookie
    %Cookie{name: "selenium", value: "is the best"}

    # Delete All the cookies
    Cookie.delete_all(session_name)

    # Getting the cookies should return an empty list
    cookies = Cookie.all(session_name)

    # Close the window
    Session.destroy(session_name)

    assert length(cookies) == 0

  end

  test "deleting one of the cookies" do
    session_name = "cookie delete one"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to site
    Navigate.to(session_name, "http://localhost:4000")

    # Create a new cookie
    cookie = %Cookie{name: "selenium", value: "is the best"}
    # Set it
    Cookie.set(session_name, cookie)

    # Delete the selenium cookie
    Cookie.delete(session_name, "selenium")

    # Cookie should not exist
    cookie = Cookie.get(session_name, "selenium")

    # Close the window
    Session.destroy(session_name)

    # The cookie should be nil
    assert is_nil(cookie)

  end

end
