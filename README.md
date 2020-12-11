# [Dr. Marvin Monroe's family therapy](https://simpsons.fandom.com/wiki/Dr._Monroe%27s_Family_Therapy_Center)

This is a didactic purpose project, which intends to walk through various elixir topics simulating Dr Marvin's therapy behavior as part of a game.
Simpson family members are analogous to elixir **processes**, which will be able to "shock" each other through **messages**.

When the application starts it will setup a TCP server to which each player can connect through a terminal and will be assigned a random character.
A player can write the command "SHOCK {CHARACTER}" to shock another character. This will make that Marvin Supervisor kill the process which holds the CHARACTER's player TCP client, and therefore force to exit.

Specs:
- Marvin is the therapy's **supervisor** and all the players are his children. He also has a key-value table where each player associates to a Simpson's character.
- Players enters the therapy establishing a TCP connection with the TCP server started by the application.
- There can be 5 players tops, the rest of the connections enter as spectators.
- A player can shock other by sending the command **SHOCK {CHARACTER}** making the shocked player to shutdown the connection.
- The shock can be public (a notification is broadcasted to all players notifying that X shocked Y) or silent (a notification is broadcasted to all players notifying that Y was shocked).


## Installation

- Clone this repository
- Open a terminal, step in project's root directory and run `iex -S mix`
- Open other terminals and use telnet to connect to the TCP server: `telnet 127.0.0.1 4040`
