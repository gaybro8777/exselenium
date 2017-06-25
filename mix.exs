defmodule Selenium.Mixfile do
  use Mix.Project

  def project do
    [app: :selenium,
     version: "0.1.0",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     description: "Elixir wrapper for selenium webdriver protocol",
     package: package(),
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      mod: {Selenium, []},
      applications: [:logger, :httpoison, :poison]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.11"},
      {:poison, "~> 3.1"},
      {:cowboy, "~> 1.0.0", only: :test},
      {:plug, "~> 1.0", only: :test},
      {:plug_basic_auth, "~> 1.1", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Nathan Johnson"],
      licenses: ["BSD"],
      links: %{"GitHub" => "https://github.com/nathanjohnson320/exselenium"}
    ]
  end
end
