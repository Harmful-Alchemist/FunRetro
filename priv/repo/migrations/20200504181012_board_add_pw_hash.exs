defmodule FunRetro.Repo.Migrations.BoardAddPwHash do
  use Ecto.Migration

  def change do
    alter table(:boards) do
      add :password_hash, :string
    end
  end
end
