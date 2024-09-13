defmodule BadDate.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BadDateWeb.Telemetry,
      BadDate.Repo,
      {Ecto.Migrator,
        repos: Application.fetch_env!(:bad_date, :ecto_repos),
        skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:bad_date, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BadDate.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: BadDate.Finch},
      # Start a worker by calling: BadDate.Worker.start_link(arg)
      # {BadDate.Worker, arg},
      # Start to serve requests, typically the last entry
      BadDateWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BadDate.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BadDateWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") != nil
  end
end
