defmodule Capabilities do
  defstruct [
    javascriptEnabled: false,
    version: "",
    rotatable: false,
    takesScreenshot: true,
    cssSelectorsEnabled: true,
    browserName: "firefox",
    nativeEvents: false,
    platform: "ANY"
  ]
end
