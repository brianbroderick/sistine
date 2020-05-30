# Sistine

This touches a table by updating id=id. It doesn't change any data, but it causes the tuple to be written to the WAL and
restreamed out to anyone subscribed to the WAL. 

Example: 

`$ mix touch --table <table> --repo <repo_name>`
`$ mix touch --table paintings --repo Sistine.Repo`

## Vacuums are built in

If we vacuum often, it will minimize table bloat since every updated row is rewritten to the bottom of the data file. Normally, PG will run a vacuum when 20% of the table's records have been changed. Since we're touching an entire table, the auto vacuum won't be able to keep up. Because of this, we'll want to run it ourselves and let it finish before resuming additional updates. 

We also run a checkpoint before running the vacuum to make sure all of the data is present in the data file before cleaning it up.

## To Run:

You'll need Erlang, Elixir, and Postgres installed. The versions for Erlang and Elixir are in .tool-versions. Currently I'm using PG10 though anything past 9.6 should be fine. 

Next, run: 

* `mix ecto.create`
* `mix ecto.migrate`
* `mix run priv/repo/seeds.exs`
* `mix touch --table paintings --repo Sistine.Repo`