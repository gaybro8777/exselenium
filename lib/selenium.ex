defmodule Selenium do
  import Supervisor.Spec

  def start(_type, _args) do

		# Add the queue as a supervised process
		children = [
      worker(Selenium.Session, [[], [name: :session]])
    ]

    # Register a sytem exit function to cleanup
    System.at_exit fn(_) ->

      # Close down all the sessions
      sessions = Selenium.Session.get_all()
      Enum.each sessions, fn ({name, _}) ->
        Selenium.Session.destroy(name)
      end

    end

		# Start the supervisor
		Supervisor.start_link(children, strategy: :one_for_one)

  end
end
