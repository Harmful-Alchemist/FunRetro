defmodule FunRetro.Retros.Drawing do
  use Ecto.Schema
  import Ecto.Changeset

  schema "drawings" do
    field :drawing, :binary
    field :lane, :string
    belongs_to :board, FunRetro.Retros.Board
    timestamps()
  end

  @doc false
  def changeset(drawing, attrs) do
    drawing
    |> cast(attrs, [:drawing, :lane, :board_id])
    |> validate_required([:drawing, :lane, :board_id])
  end
end
