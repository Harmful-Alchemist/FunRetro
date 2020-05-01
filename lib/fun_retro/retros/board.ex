defmodule FunRetro.Retros.Board do
  use Ecto.Schema
  import Ecto.Changeset

  schema "boards" do
    field :lanes, {:array, :string}
    field :name, :string
    has_many :drawings, FunRetro.Retros.Drawing

    timestamps()
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:name, :lanes])
    |> validate_required([:name, :lanes])
    |> validate_length(:lanes, max: 6)
    |> validate_length(:lanes, min: 1)
  end
end
