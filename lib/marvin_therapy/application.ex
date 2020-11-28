defmodule MarvinTherapy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # TODO get port from config
    port = 4040

    children = [
      {Task.Supervisor, name: MarvinTherapy.MarvinSupervisor},
      MarvinTherapy.Marvin,
      Supervisor.child_spec({Task, fn -> MarvinTherapy.TcpServer.accept(port) end}, restart: :permanent)
    ]

    :debugger.start()
    :int.ni MarvinTherapy.TcpServer
    :int.ni MarvinTherapy.Marvin

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MarvinTherapy.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
