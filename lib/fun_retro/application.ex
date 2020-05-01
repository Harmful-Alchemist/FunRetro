defmodule FunRetro.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      FunRetro.Repo,
      # Start the Telemetry supervisor
      FunRetroWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: FunRetro.PubSub},
      # Start the Endpoint (http/https)
      FunRetroWeb.Endpoint
      # Start a worker by calling: FunRetro.Worker.start_link(arg)
      # {FunRetro.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FunRetro.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    FunRetroWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
