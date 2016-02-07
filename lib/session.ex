defmodule Selenium.Session do
  alias Selenium.Request
  alias Selenium.Capabilities

  def start_link(state \\ [], opts \\ []) do
    Agent.start_link fn -> %{} end, name: __MODULE__
  end

  # Gets a session ID for a given identifier
  def get(identifier) do
    Agent.get __MODULE__, fn(state) ->
      state[identifier]
    end
  end

  # Get all the selenium sessions, useful for termination
  def get_all() do
    Agent.get __MODULE__, fn(state) ->
      state
    end
  end

  # Creates a new session given an identifier, the browser type, and
  # any extra capabilities.
  def create(identifier, browser, additional_capabilities \\ %{}) do

    capabilities = %Capabilities{
      browserName: browser
    }

    params = %{
      desiredCapabilities: Map.merge(capabilities, additional_capabilities)
    }

    session_id = get(identifier)
    if not is_nil session_id do
      raise "Session already exists for key #{identifier}"
    end

    # Send the request to make a new session
    session_id = case Request.post("session", params, [recv_timeout: :infinity]) do
      {:error, %HTTPoison.Error{id: nil, reason: :econnrefused}} -> raise "Could not connect to selenium server"
      {:ok, %HTTPoison.Response{body: %{ "sessionId" => session_id }} } -> session_id
    end

    # Add the session ID to our state
    Agent.update __MODULE__, fn(state) ->
      Map.put(state, identifier, session_id)
    end

    session_id
  end

  # Destroys a session for a given identifier
  def destroy(identifier) do

    # Get the session ID for the identifier
    session_id = get(identifier)

    # Send a delete to the session to clean it up
    Request.delete("session/#{session_id}", [recv_timeout: :infinity])

    # Remove the identifier from the state
    Agent.get_and_update __MODULE__, fn(state) ->
      { Map.fetch(state, identifier), Map.delete(state, identifier)}
    end
  end

end
