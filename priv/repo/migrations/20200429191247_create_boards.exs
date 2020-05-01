defmodule FunRetro.Repo.Migrations.CreateBoards do
  use Ecto.Migration

  def change do
    create table(:boards) do
      add :name, :string
      add :lanes, {:array, :string}

      timestamps()
    end
  end
end
