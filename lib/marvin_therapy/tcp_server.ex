defmodule MarvinTherapy.TcpServer do
  require Logger

  @doc """
  Accepts client connections on port
  """
  def accept(port) do
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])

    Logger.info("Waiting for players to connect...")

    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)

    {:ok, pid} = Task.Supervisor.start_child(MarvinTherapy.MarvinSupervisor, fn -> serve(client) end)
    :ok = :gen_tcp.controlling_process(client, pid)

    if MarvinTherapy.Marvin.are_available_characters? do
      character = MarvinTherapy.Marvin.add(client)
      :gen_tcp.send(client, "You are playing as #{character}\r\n")
    else
      :gen_tcp.send(client, "The room is full. You are a spectator.\r\n")
    end

    loop_acceptor(socket)
  end

  defp serve(client) do
    response = recv(client)

    :ok = :gen_tcp.send(client, response)

    serve(client)
  end

  defp recv(client) do
    case :gen_tcp.recv(client, 0) do
      {:ok, command} -> execute(client, command)
      {:error, reason} -> "An error occurred: #{reason}"
    end
  end

  defp execute(client, command) do
    if MarvinTherapy.Marvin.is_playing?(client) do
      #TODO execute command sent by player
      MarvinTherapy.Marvin.electrocute(command)
    else
      "You are a spectator\r\n"
    end
  end
end
