defmodule FunRetro.Repo.Migrations.AddLaneToDrawing do
  use Ecto.Migration

  def change do
    alter table(:drawings) do
      add :lane, :string
    end
  end
end
