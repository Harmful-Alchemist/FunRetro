defmodule FunRetro.Repo.Migrations.AddBoardToDrawing do
  use Ecto.Migration

  def change do
    alter table(:drawings) do
      add :board_id, references(:boards)
    end
  end
end
