defmodule ElementTest do
  use ExUnit.Case

  alias Selenium.Session
  alias Selenium.Commands.Navigate
  alias Selenium.Commands.Element

  doctest Element

  test "find a single element" do
    session_name = "element find one"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facebook
    Navigate.to(session_name, "https://www.facebook.com")

    # Use all the element selectors
    assert Element.find_one(session_name, "class", "_li") == "0"
    assert Element.find_one(session_name, "css", "i.fb_logo") == "1"
    assert Element.find_one(session_name, "id", "content") == "2"
    assert Element.find_one(session_name, "name", "email") == "3"

    # These two are the same link
    assert Element.find_one(session_name, "link", "Sign Up") == "4"
    assert Element.find_one(session_name, "partial link", "Sign") == "4"

    assert Element.find_one(session_name, "tag", "h1") == "5"
    assert Element.find_one(session_name, "xpath", "//div/h1/a/i/u") == "6"

    # Nonexistant elements should be nil
    assert Element.find_one(session_name, "css", ".nonexistantclass") |> is_nil()

    # This one should error
    assert_raise RuntimeError, "Invalid element selection strategy", fn() ->
      Element.find_one(session_name, "xpathes", "/nonsense######!@$%")
    end

    # Close the window
    Session.destroy(session_name)

  end

  test "finding all elements" do
    session_name = "element find all"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facebook
    Navigate.to(session_name, "https://www.facebook.com")

    # Grab all the inputs, there should be 33 of them
    assert length(Element.find_all(session_name, "tag", "input")) == 33

    # Close the window
    Session.destroy(session_name)
  end

  test "finding the active element" do
    session_name = "element find active"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facebook
    Navigate.to(session_name, "https://www.facebook.com")

    # The active element should be 0 and it's the window
    assert Element.get_active(session_name) == "0"

    # Close the window
    Session.destroy(session_name)
  end

  test "finding an element inside of an element" do
    session_name = "element find within"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facebook
    Navigate.to(session_name, "https://www.facebook.com")

    # Find the blue bar and then the email within that
    element = Element.find_one(session_name, "id", "blueBarDOMInspector") |> Element.find_within(session_name, "id", "email")

    # ElementID should be 1
    assert element == "1"

    # Close the window
    Session.destroy(session_name)
  end

  test "finding elements inside of an element" do
    session_name = "element find multiple within"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facebook
    Navigate.to(session_name, "https://www.facebook.com")

    # Find the content div and then the inputs within that
    elements = Element.find_one(session_name, "id", "content") |> Element.find_multiple_within(session_name, "tag", "input")

    assert length(elements) == 21

    # Close the window
    Session.destroy(session_name)
  end

  test "clicking an element" do
    session_name = "element click"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facebook
    Navigate.to(session_name, "https://www.facebook.com")

    # Find the submit button and click it
    result = Element.find_one(session_name, "css", "input[type=\"submit\"]") |> Element.click(session_name)
    result_nonexistant = Element.find_one(session_name, "css", "garbagio") |> Element.click(session_name)

    # The result should be true if clicking an element worked, nonexistant should be false
    assert result
    refute result_nonexistant

    # Close the window
    Session.destroy(session_name)
  end

  test "submitting an element" do
    session_name = "element submit"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facebook
    Navigate.to(session_name, "https://www.facebook.com")

    # Submit the login
    result = Element.find_one(session_name, "id", "login_form") |> Element.submit(session_name)

    # The result should be true if clicking an element worked, nonexistant should be false
    assert result

    # Close the window
    Session.destroy(session_name)
  end

  test "getting an element's text" do
    session_name = "element text"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facebook
    Navigate.to(session_name, "https://www.facebook.com")

    # Get the copyright text
    text = Element.find_one(session_name, "class", "copyright") |> Element.text(session_name)

    assert text == "Facebook © 2016\nEnglish (US)"

    # Close the window
    Session.destroy(session_name)
  end

  test "getting an attribute" do
    session_name = "element attribute"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facebook
    Navigate.to(session_name, "https://www.facebook.com")

    # Get the logo
    title = Element.find_one(session_name, "xpath", "//*[@id=\"blueBarDOMInspector\"]/div/div/div/div/div[1]/h1/a") |> Element.attribute(session_name, "title")

    # The logos title should be about facebook home
    assert title == "Go to Facebook Home"

    # Close the window
    Session.destroy(session_name)
  end

  test "getting an element's html" do
    session_name = "element html"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facebook
    Navigate.to(session_name, "https://www.facebook.com")

    # Get the copyright inner HTML
    inner_html = Element.find_one(session_name, "class", "copyright") |> Element.html(session_name, false)

    # Get the outer html
    outer_html = Element.find_one(session_name, "class", "copyright") |> Element.html(session_name, true)

    assert inner_html == "<div><span> Facebook © 2016</span><div class=\"fsm fwn fcg\"><a rel=\"dialog\" ajaxify=\"/settings/language/language/?uri=https%3A%2F%2Fwww.facebook.com%2F&amp;source=TOP_LOCALES_DIALOG\" title=\"Use Facebook in another language.\" href=\"#\" role=\"button\">English (US)</a></div></div>"

    assert outer_html == "<div class=\"mvl copyright\"><div><span> Facebook © 2016</span><div class=\"fsm fwn fcg\"><a rel=\"dialog\" ajaxify=\"/settings/language/language/?uri=https%3A%2F%2Fwww.facebook.com%2F&amp;source=TOP_LOCALES_DIALOG\" title=\"Use Facebook in another language.\" href=\"#\" role=\"button\">English (US)</a></div></div></div>"

    # Close the window
    Session.destroy(session_name)
  end

  test "setting an element's value" do
    session_name = "element set value"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facebook
    Navigate.to(session_name, "https://www.facebook.com")

    # Set the email
    element = Element.find_one(session_name, "id", "email")
    result = Element.set_value(element, session_name, "testing1234")

    # Should work
    assert result

    # The value should be testing1234
    value = Element.attribute(element, session_name, "value")
    assert value == "testing1234"

    # Close the window
    Session.destroy(session_name)
  end

  test "sending keys" do
    session_name = "element send keys"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facebook
    Navigate.to(session_name, "https://www.facebook.com")

    # Focus the email div
    element = Element.find_one(session_name, "id", "email")
    Element.click(element, session_name)

    # Send keys to the focused element
    Element.keys(session_name, "testing1234")

    # The value should be testing1234
    value = Element.attribute(element, session_name, "value")
    assert value == "testing1234"

    # Close the window
    Session.destroy(session_name)
  end

  test "getting an element's tag name" do
    session_name = "element tag name"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facebook
    Navigate.to(session_name, "https://www.facebook.com")

    # Get the email name
    tag = Element.find_one(session_name, "id", "email") |> Element.tag_name(session_name)

    assert tag == "input"

    # Close the window
    Session.destroy(session_name)
  end

  test "clearing an element's value" do
    session_name = "element clear"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facebook
    Navigate.to(session_name, "https://www.facebook.com")

    # Set the email
    element = Element.find_one(session_name, "id", "email")
    Element.set_value(element, session_name, "testing1234")

    # Blank the field
    Element.clear(element, session_name)

    # The value should be blanked once we've cleared it
    value = Element.attribute(element, session_name, "value")
    assert value == ""

    # Close the window
    Session.destroy(session_name)
  end

  test "checking if element is selected" do
    session_name = "element selected"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facebook
    Navigate.to(session_name, "https://www.facebook.com")

    # Check the remember me box
    element = Element.find_one(session_name, "id", "persist_box")
    Element.click(element, session_name)

    # checkbox should be selected
    assert Element.selected(element, session_name)

    # Close the window
    Session.destroy(session_name)
  end

  test "checking if element is enabled" do
    session_name = "element enabled"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facebook
    Navigate.to(session_name, "https://www.facebook.com")

    # Is the login button enabled
    result = Element.find_one(session_name, "css", "input[type=submit]") |> Element.enabled(session_name)

    # It should be enabled
    assert result

    # Close the window
    Session.destroy(session_name)
  end

  test "checking if elements are equal" do
    session_name = "element equal"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facebook
    Navigate.to(session_name, "https://www.facebook.com")

    # Login and email should be different
    login_button = Element.find_one(session_name, "css", "input[type=submit]")
    email_input = Element.find_one(session_name, "id", "email")

    result = Element.equal(login_button, session_name, email_input)

    # It should be enabled
    refute result

    # Close the window
    Session.destroy(session_name)
  end

  test "checking if an element is displayed" do
    session_name = "element displayed"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facebook
    Navigate.to(session_name, "https://www.facebook.com")

    # Email should be displayed
    result = Element.find_one(session_name, "id", "email") |> Element.displayed(session_name)
    assert result

    # Close the window
    Session.destroy(session_name)
  end

  test "getting an element's location" do
    session_name = "element location"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facebook
    Navigate.to(session_name, "https://www.facebook.com")

    # Email should be in the top right
    result = Element.find_one(session_name, "id", "email") |> Element.location(session_name)
    assert result == %{"x" => 652, "y" => 33}

    # Close the window
    Session.destroy(session_name)
  end

  test "getting an element's size" do
    session_name = "element size"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facebook
    Navigate.to(session_name, "https://www.facebook.com")

    # Email should be in the top right
    result = Element.find_one(session_name, "id", "email") |> Element.size(session_name)
    assert result == %{"height" => 22, "width" => 150}

    # Close the window
    Session.destroy(session_name)
  end

  test "getting a css attribute" do
    session_name = "element css"

    # Create a new session
    Session.create(session_name, "firefox")

    # Go to facebook
    Navigate.to(session_name, "https://www.facebook.com")

    # Email should be 12.5px tall
    result = Element.find_one(session_name, "id", "email") |> Element.css(session_name, "height")
    assert result == "12.5px"

    # Close the window
    Session.destroy(session_name)
  end

end
