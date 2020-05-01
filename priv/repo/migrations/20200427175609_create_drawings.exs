defmodule FunRetro.Repo.Migrations.CreateDrawings do
  use Ecto.Migration

  def change do
    create table(:drawings) do
      add :drawing, :binary

      timestamps()
    end
  end
end
