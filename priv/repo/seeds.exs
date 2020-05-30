# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Sistine.Repo.insert!(%Sistine.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Sistine.{Repo}

Ecto.Adapters.SQL.query!(
  Repo,
  "TRUNCATE paintings"
)

Ecto.Adapters.SQL.query!(
  Repo,
  "ALTER SEQUENCE paintings_id_seq RESTART WITH 1;"
)

items = [
  %{name: "Chapel Ceiling", artist: "Michelangelo"},
  %{
    name: "The Creation of the Sun, Moon, and Plants",
    artist: "Michelangelo"
  },
  %{
    name: "Punishment of the Sons of Korah",
    artist: "Sandro Botticelli"
  },
  %{name: "Expulsion from the Garden of Eden", artist: "Masaccio"},
  %{name: "Sacrifice of Noah", artist: "Michelangelo"},
  %{name: "The Deluge", artist: "Michelangelo"},
  %{name: "Youth of Moses", artist: "Sandro Botticelli"},
  %{name: "Persian Sibyl", artist: "Michelangelo"},
  %{name: "Erythraean Sibyl", artist: "Michelangelo"},
  %{name: "The Brazen Serpent", artist: "Michelangelo"}
]

current_time = DateTime.utc_now()

Enum.each(items, fn item ->
  instances =
    Enum.map(1..13_000, fn x ->
      record = Map.put(item, :rating, x)
      record = Map.put(record, :inserted_at, current_time)
      record = Map.put(record, :updated_at, current_time)
      record
    end)

  Repo.insert_all("paintings", instances)
end)
