defmodule FunRetro.Retros.Board do
  use Ecto.Schema
  import Ecto.Changeset

  schema "boards" do
    field :lanes, {:array, :string}
    field :name, :string
    has_many :drawings, FunRetro.Retros.Drawing
    field :password, :string, virtual: true
    field :password_hash, :string

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

  @doc false
  def registration_changeset(board, params) do
    board
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 9, max: 128)
    |> put_pass_hash()
  end

  @doc false
  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end
end
