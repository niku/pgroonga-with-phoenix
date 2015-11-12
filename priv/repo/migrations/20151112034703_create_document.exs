defmodule DocumentSearch.Repo.Migrations.CreateDocument do
  use Ecto.Migration

  def change do
    create table(:documents) do
      add :title, :text
      add :content, :text

      timestamps
    end

  end
end
