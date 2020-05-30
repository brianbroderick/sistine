defmodule Sistine.Repo.Migrations.CreatePaintings do
  use Ecto.Migration

  def up do
    create table(:paintings) do
      add :name, :string
      add :artist, :string
      add :rating, :integer

      add :last_modified_at, :utc_datetime
      timestamps()
    end

    execute """
    CREATE FUNCTION public.generate_last_modified_at() RETURNS trigger
      LANGUAGE plpgsql
      AS $$
    BEGIN
      NEW.last_modified_at = timezone('utc', now());
      RETURN NEW;
    END;
    $$;
    """

    execute """
      CREATE TRIGGER paintings_generate_last_modified_at
      BEFORE INSERT OR UPDATE ON paintings
      FOR EACH ROW EXECUTE PROCEDURE generate_last_modified_at();
    """
  end

  def down do
    execute "DROP TRIGGER IF EXISTS paintings_generate_last_modified_at ON paintings;"
    execute "DROP FUNCTION IF EXISTS public.generate_last_modified_at();"
    drop table(:paintings)
  end
end
