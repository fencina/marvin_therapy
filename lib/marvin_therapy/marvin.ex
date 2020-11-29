defmodule MarvinTherapy.Marvin do
  use GenServer

  @moduledoc """
  Marvin has a table where stores the state of each character

  TODO If Marvin crashes it must reload the players table with the current
  TCP connections availables
  """

  # Client

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def add(player) do
    GenServer.call(__MODULE__, {:add, player})
  end

  def shock(character) do
    GenServer.call(__MODULE__, {:shock, character})
  end

  def are_available_characters? do
    GenServer.call(__MODULE__, {:are_available_characters?})
  end

  def is_playing?(client) do
    GenServer.call(__MODULE__, {:is_playing?, client})
  end

  # Server

  @impl true
  def init(_args) do
    # TODO make players an ETS for concurrency access.
    # For now, though, is not necessary as there is only one Marvin (GenServer)
    # and the messages received are consumed sequentially FIFO
    players = %{}

    # TODO get available characters from a config
    available_characters = ["HOMERO", "MARGE"] #, "BART", "LISA", "MAGGIE"]

    {:ok, {players, available_characters}}
  end

  @impl true
  def handle_call({:add, player}, _from, {players, available_characters}) do
    # TODO get random character
    {character, available_characters} = List.pop_at(available_characters, 0)

    players = Map.put(players, character, player)

    {:reply, character, {players, available_characters}}
  end

  @impl true
  def handle_call({:shock, character}, _from, {players, available_characters}) do
    # TODO sent notification to all players connected
    character = character |> String.trim |> String.upcase

    if Map.has_key?(players, character) do
      {player, players} = Map.pop(players, character)

      Process.exit(player, :kill)

      # REMEMBER: prepending an element to a list is always faster (constant time)
      # than appending it (linear time). See https://hexdocs.pm/elixir/List.html
      available_characters = [character | available_characters]
      {:reply, "Electrocutado #{character}", {players, available_characters}}
    else
      {:reply, "#{character} is not playing or character does not exists\r\n", {players, available_characters}}
    end
  end

  @impl true
  def handle_call({:are_available_characters?}, _from, {players, available_characters}) do
    {:reply, length(available_characters) > 0, {players, available_characters}}
  end

  @impl true
  def handle_call({:is_playing?, client}, _from, {players, available_characters}) do
    clients = Map.values(players)
    {:reply, client == get_player(clients, client), {players, available_characters}}
  end

  defp get_player([], _) do
    nil
  end

  defp get_player(clients, client) when is_list(clients) do
    [possible_client | tail] = clients

    if possible_client != client do
      get_player(tail, client)
    else
      possible_client
    end
  end
end
