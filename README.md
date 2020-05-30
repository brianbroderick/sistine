# Sistine

This touches a table by updating id=id. It doesn't change any data, but it causes the tuple to be written to the WAL and
restreamed out to anyone subscribed to the WAL. 

Examples: 

* `$ mix touch --table <table> --repo <repo_name>`
* `$ mix touch --table paintings --repo Sistine.Repo`

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

## Tests

I believe the test doesn't work because Ecto doesn't commit transactions when it runs tests. I'm testing that it works by looking at the "last_modified_at" column. This has a trigger that updates when the row is updated. Since the transaction doesn't commit, the trigger isn't getting run. 

I could change the tests to not use the Sandbox, but that doesn't help if this example gets used in other repos. I don't want to change any of the actual data because that defeats the point of simply "touching" the record. 