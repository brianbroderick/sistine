defmodule Mix.Tasks.TouchTest do
  import Ecto.Query, warn: false
  use Sistine.DataCase
  alias Sistine.{Art.Painting, Repo}

  ### Because Ecto doesn't actually commit the transaction, 
  # it won't actually update the last_modified_at column because that comes from a trigger. 

  describe "run/1" do
    test "successfully touches the records" do
      insert_list(10, :painting)
      # :timer.sleep(1000)

      Mix.Tasks.Touch.run(["--table", "paintings", "--repo", "Sistine.Repo"])

      query =
        from p in Painting,
          where: p.name == "Chapel Ceiling",
          select: struct(p, [:inserted_at, :last_modified_at]),
          limit: 1

      record = Repo.one(query)
      assert(record.last_modified_at > record.inserted_at)
    end
  end
end
