defmodule Pooly.WorkerSupervisor do
  use Supervisor

  #######
  # API #
  #######

  def start_link({_,_,_} = mfa) do
    Supervisor.start_link(__MODULE__, mfa)
  end

  #############
  # Callbacks #
  #############

  # The supervisor initially starts out with empty workers. Workers are then
  # dynamically attached to the supervisor.
  #
  # max_restarts and max_seconds translate to the maximum number of restarts
  # the supervisor can tolerate within a maximum number of seconds before it
  # gives up and terminates.
  #
  def init({m, f, a}) do
    worker_opts = [restart: :permanent,
                   function: f]

    # This supervisor has one child, or one kind of child, in the case of a
    # :simple_one_for_one restart strategy, because it doesn't make sense to
    # define multiple workers.
    children = [worker(m, a, worker_opts)]
    opts     = [strategy: :simple_one_for_one,
                max_restarts: 5,
                max_seconds: 5]

    supervise(children, opts)
  end
end
