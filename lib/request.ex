defmodule Selenium.Request do

  # Module to handle HTTP requests in a uniform fashion
  use HTTPoison.Base

  # prepend the url with the server api route
  def process_url(url) do
    api_url <> url
  end

  # Response body should always be decoded, unless it can't then
  # we respond with the text version
  def process_response_body(body) do
    try do
      Poison.decode!(body)
    rescue
      _ -> body
    end
  end


  # Convert request body to JSON
  def process_request_body(body) do
    if body != "" do
      Poison.encode!(body)
    else
      body
    end
  end

  # Set the headers to JSON
  def process_request_headers(headers) do
    [{'content-type', 'application/json'} | headers]
  end

  # API url helper - will work in any env
  defp api_url do

    # Grab our config variables for selenium host and port
    host = Application.get_env(:selenium, :hostname)
    port = Application.get_env(:selenium, :port)

    # Selenium path is wd/hub
    "http://#{host}:#{port}/wd/hub/"
  end
end
