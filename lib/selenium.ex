defmodule Selenium do
  import Supervisor.Spec

  def start(_type, _args) do

		# Add the queue as a supervised process
		children = [
      worker(Selenium.Session, [[], [name: :session]])
    ]

		# Start the supervisor
		Supervisor.start_link(children, strategy: :one_for_one)
  end
end
