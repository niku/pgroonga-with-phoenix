defmodule DocumentSearch.Repo.Migrations.AddFullTextSearchIndexToDocuments do
  use Ecto.Migration

  def change do
    index(:documents, [:content], using: "pgroonga")
  end
end
