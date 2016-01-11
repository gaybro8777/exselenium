defmodule SessionTest do
  use ExUnit.Case
  alias Selenium.Session
  doctest Session

  test "create and destroy session" do
    session_name = "session"

    # Create a new session
    session = Session.create(session_name, "firefox")
    assert Regex.match?(~r/^[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}$/, session)

    # Duplicate session names should error
    assert catch_error(Session.create(session_name, "firefox"))

    # Get should return the same session id
    assert Session.get(session_name) == session

    # Destroy the session
    {status, session} = Session.destroy(session_name)

    # Should return ok status
    assert status == :ok

    # Session ID is random but we know it's 36 characters long
    assert Regex.match?(~r/^[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}$/, session)
  end

end
