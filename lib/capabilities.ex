defmodule Selenium.Capabilities do
  defstruct [
    javascriptEnabled: false,
    version: "",
    rotatable: false,
    takeScreenshot: true,
    cssSelectorsEnabled: true,
    browserName: "firefox",
    nativeEvents: false,
    platform: "ANY"
  ]
end
