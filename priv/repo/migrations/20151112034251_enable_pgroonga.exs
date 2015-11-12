defmodule DocumentSearch.Repo.Migrations.EnablePgroonga do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION pgroonga;"
    execute """
    ALTER DATABASE #{current_database}
    SET search_path = '$user', public, pgroonga, pg_catalog;
    """
  end

  def down do
    execute "ALTER DATABASE #{current_database} RESET search_path;"
    execute "DROP EXTENSION pgroonga CASCADE;"
  end

  defp current_database, do: Application.get_env(:document_search, DocumentSearch.Repo)[:database]
end
