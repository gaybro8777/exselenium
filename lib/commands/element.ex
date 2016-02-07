defmodule Selenium.Commands.Element do
  alias Selenium.Session
  alias Selenium.Request
  alias Selenium.Position

  # Map all the strategies
  @strategies %{ "class" => "class name", "css" => "css selector", "id" => "id", "name" => "name", "link" => "link text", "partial link" => "partial link text", "tag" => "tag name", "xpath" => "xpath" }

  # Find a single element based on a strategy and selector
  def find_one(identifier, strategy, selector) do
    HTTPoison.start()
    session_id = Session.get(identifier)

    # Get the mapped strategy value
    strat = @strategies[strategy]

    if is_nil(strat), do: raise "Invalid element selection strategy"

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/element", %{"using" => strat, "value" => selector}, [recv_timeout: :infinity])

    body["value"]["ELEMENT"]
  end

  # Find all elements with selector
  def find_all(identifier, strategy, selector) do
    HTTPoison.start()
    session_id = Session.get(identifier)

    # Get the mapped strategy value
    strat = @strategies[strategy]

    if is_nil(strat), do: raise "Invalid element selection strategy"

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/elements", %{"using" => strat, "value" => selector}, [recv_timeout: :infinity])

    # Return a list of element IDs
    Enum.map body["value"], fn(element) ->
      element["ELEMENT"]
    end
  end

  # Find the active element
  def get_active(identifier) do
    HTTPoison.start()
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/element/active", "", [recv_timeout: :infinity])

    body["value"]["ELEMENT"]
  end

  # Find a single element based on a strategy and selector
  def find_within(id, identifier, strategy, selector) do
    HTTPoison.start()
    session_id = Session.get(identifier)

    # Get the mapped strategy value
    strat = @strategies[strategy]

    if is_nil(strat), do: raise "Invalid element selection strategy"

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/element/#{id}/element", %{"using" => strat, "value" => selector}, [recv_timeout: :infinity])

    body["value"]["ELEMENT"]
  end

  # Find multiple elements based on a strategy and selector
  def find_multiple_within(id, identifier, strategy, selector) do
    HTTPoison.start()
    session_id = Session.get(identifier)

    # Get the mapped strategy value
    strat = @strategies[strategy]

    if is_nil(strat), do: raise "Invalid element selection strategy"

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/element/#{id}/elements", %{"using" => strat, "value" => selector}, [recv_timeout: :infinity])

    Enum.map body["value"], fn(element) ->
      element["ELEMENT"]
    end
  end

  # Click on an element
  def click(id, identifier) do
    HTTPoison.start()
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/element/#{id}/click", "", [recv_timeout: :infinity])

    body["state"] == "success"
  end

  # Submit an element
  def submit(id, identifier) do
    HTTPoison.start()
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/element/#{id}/submit", "", [recv_timeout: :infinity])

    body["state"] == "success"
  end

  # Get the text of an element
  def text(id, identifier) do
    HTTPoison.start()
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.get("session/#{session_id}/element/#{id}/text", [recv_timeout: :infinity])

    body["value"]
  end

  # Get the attribute of an element
  def attribute(id, identifier, attribute) do
    HTTPoison.start()
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.get("session/#{session_id}/element/#{id}/attribute/#{attribute}", [recv_timeout: :infinity])

    body["value"]
  end

  # Get the attribute of an element
  def html(id, identifier, outer \\ true) do

    # Get the attribute based on the identifier
    case outer do
      true -> attribute(id, identifier, "outerHTML")
      false -> attribute(id, identifier, "innerHTML")
      _ -> raise "For HTML the last parameter must be true or false"
    end
  end

  # Set the value of an element
  def set_value(id, identifier, value) do
    HTTPoison.start()
    # Value needs to be an array of characters
    value = String.split value, ~r//, trim: true

    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/element/#{id}/value", %{ "value" => value}, [recv_timeout: :infinity])

    body["state"] == "success"
  end

  # Trigger key presses in the active element
  def keys(identifier, value) do
    HTTPoison.start()
    # Value needs to be an array of characters
    value = String.split value, ~r//, trim: true

    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/keys", %{ "value" => value}, [recv_timeout: :infinity])

    body["state"] == "success"
  end

  # Get an element's tag name
  def tag_name(id, identifier) do
    HTTPoison.start()
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.get("session/#{session_id}/element/#{id}/name", [recv_timeout: :infinity])

    body["value"]
  end

  # Set the value of an element
  def clear(id, identifier) do
    HTTPoison.start()
    session_id = Session.get(identifier)
    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.post("session/#{session_id}/element/#{id}/clear", "", [recv_timeout: :infinity])

    body["state"] == "success"
  end

  # Tell if an element is selected
  def selected(id, identifier) do
    HTTPoison.start()
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.get("session/#{session_id}/element/#{id}/selected", [recv_timeout: :infinity])

    body["value"]
  end

  # Is an element enabled
  def enabled(id, identifier) do
    HTTPoison.start()
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.get("session/#{session_id}/element/#{id}/enabled", [recv_timeout: :infinity])

    body["value"]
  end

  # Are the two elements equal
  def equal(id, identifier, other_id) do
    HTTPoison.start()
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.get("session/#{session_id}/element/#{id}/equals/#{other_id}", [recv_timeout: :infinity])

    body["value"]
  end

  # Is an element displayed on the page?
  def displayed(id, identifier) do
    HTTPoison.start()
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.get("session/#{session_id}/element/#{id}/displayed", [recv_timeout: :infinity])

    body["value"]
  end

  # Get the location of an element
  def location(id, identifier) do
    HTTPoison.start()
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.get("session/#{session_id}/element/#{id}/location", [recv_timeout: :infinity])

    %Position{ x: body["value"]["x"], y: body["value"]["y"] }
  end

  # Get the size of an element
  def size(id, identifier) do
    HTTPoison.start()
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.get("session/#{session_id}/element/#{id}/size", [recv_timeout: :infinity])

    %{ "width" => body["value"]["width"], "height" => body["value"]["height"] }
  end

  # Get the size of an element
  def css(id, identifier, property) do
    HTTPoison.start()
    session_id = Session.get(identifier)

    {:ok, %HTTPoison.Response{body: body,
                              headers: _,
                              status_code: _}} = Request.get("session/#{session_id}/element/#{id}/css/#{property}", [recv_timeout: :infinity])

    body["value"]
  end

end
