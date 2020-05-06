defmodule FunRetro.Retros do
  @moduledoc """
  The Retros context.
  """

  import Ecto.Query, warn: false
  alias FunRetro.Repo

  alias FunRetro.Retros.Drawing

  @doc """
  Returns the list of drawings for a board.

  ## Examples

      iex> list_drawings(board_id)
      [%Drawing{}, ...]

  """
  def list_drawings(board_id) do
    query =
      from d in Drawing,
        where: d.board_id == type(^board_id, :integer)

    Repo.all(query)
  end

  @doc """
  Gets a single drawing.

  Raises `Ecto.NoResultsError` if the Drawing does not exist.

  ## Examples

      iex> get_drawing!(123)
      %Drawing{}

      iex> get_drawing!(456)
      ** (Ecto.NoResultsError)

  """
  def get_drawing!(id), do: Repo.get!(Drawing, id)

  @doc """
  Creates a drawing.

  ## Examples

      iex> create_drawing(%{field: value})
      {:ok, %Drawing{}}

      iex> create_drawing(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_drawing(attrs \\ %{}) do
    %Drawing{}
    |> Drawing.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a drawing.

  ## Examples

      iex> update_drawing(drawing, %{field: new_value})
      {:ok, %Drawing{}}

      iex> update_drawing(drawing, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_drawing(%Drawing{} = drawing, attrs) do
    drawing
    |> Drawing.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a drawing.

  ## Examples

      iex> delete_drawing(drawing)
      {:ok, %Drawing{}}

      iex> delete_drawing(drawing)
      {:error, %Ecto.Changeset{}}

  """
  def delete_drawing(%Drawing{} = drawing) do
    Repo.delete(drawing)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking drawing changes.

  ## Examples

      iex> change_drawing(drawing)
      %Ecto.Changeset{data: %Drawing{}}

  """
  def change_drawing(%Drawing{} = drawing, attrs \\ %{}) do
    Drawing.changeset(drawing, attrs)
  end

  alias FunRetro.Retros.Board

  @doc """
  Returns the list of boards.

  ## Examples

      iex> list_boards()
      [%Board{}, ...]

  """
  def list_boards do
    Repo.all(Board)
  end

  @doc """
  Gets a single board.

  Raises `Ecto.NoResultsError` if the Board does not exist.

  ## Examples

      iex> get_board!(123)
      %Board{}

      iex> get_board!(456)
      ** (Ecto.NoResultsError)

  """
  def get_board!(id) do
    query =
      from b in Board,
        preload: [:drawings]

    Repo.get!(query, id)
  end

  @doc """
  Gets a single board.

  Raises `Ecto.NoResultsError` if the Board does not exist.

  ## Examples

      iex> get_board!(123)
      %Board{}

      iex> get_board!(456)
      ** (Ecto.NoResultsError)

  """
  def get_board_without_drawings!(id) do
    Repo.get!(Board, id)
  end

  @doc """
  Get lanes from a single board.

  Raises `Ecto.NoResultsError` if the Board does not exist.

  ## Examples

    iex> get_lanes_board!(123)
    []

    iex> get_lanes_board!(456)
    ** (Ecto.NoResultsError)


  """
  def get_lanes_board!(id) do
    query =
      from b in Board,
        select: b.lanes

    Repo.get!(query, id)
  end

  @doc """
  Creates a board.

  ## Examples

      iex> create_board(%{field: value})
      {:ok, %Board{}}

      iex> create_board(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_board(attrs \\ %{}) do
    %Board{}
    |> Board.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a board.

  ## Examples

      iex> update_board(board, %{field: new_value})
      {:ok, %Board{}}

      iex> update_board(board, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_board(%Board{} = board, attrs) do
    board
    |> Board.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a board.

  ## Examples

      iex> delete_board(board)
      {:ok, %Board{}}

      iex> delete_board(board)
      {:error, %Ecto.Changeset{}}

  """
  def delete_board(%Board{} = board) do
    Repo.delete(board)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking board changes.

  ## Examples

      iex> change_board(board)
      %Ecto.Changeset{data: %Board{}}

  """
  def change_board(%Board{} = board, attrs \\ %{}) do
    Board.changeset(board, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking board changes. With a password field.

  ## Examples

      iex> change_board(board)
      %Ecto.Changeset{data: %Board{}}

  """
  def change_registration(%Board{} = board, params) do
    Board.registration_changeset(board, params)
  end

  @doc """
  Creates a board, with a hashed password.

  ## Examples

      iex> create_board(%{field: value})
      {:ok, %Board{}}

      iex> create_board(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_board(attrs \\ %{}) do
    %Board{}
    |> Board.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc false
  def authenticate_board(board_id, given_pass) do
    board = get_board_without_drawings!(board_id)

    cond do
      board && Pbkdf2.verify_pass(given_pass, board.password_hash) ->
        {:ok, board}

      board ->
        {:error, :unauthorized}

      true ->
        Pbkdf2.no_user_verify()
        {:error, :not_found}
    end
  end
end
