defmodule FunRetro.RetrosTest do
  use FunRetro.DataCase

  alias FunRetro.Retros

  describe "drawings" do
    alias FunRetro.Retros.Drawing

    @valid_attrs %{drawing: "some drawing"}
    @update_attrs %{drawing: "some updated drawing"}
    @invalid_attrs %{drawing: nil}

    def drawing_fixture(attrs \\ %{}) do
      {:ok, drawing} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Retros.create_drawing()

      drawing
    end

    test "list_drawings/0 returns all drawings" do
      drawing = drawing_fixture()
      assert Retros.list_drawings() == [drawing]
    end

    test "get_drawing!/1 returns the drawing with given id" do
      drawing = drawing_fixture()
      assert Retros.get_drawing!(drawing.id) == drawing
    end

    test "create_drawing/1 with valid data creates a drawing" do
      assert {:ok, %Drawing{} = drawing} = Retros.create_drawing(@valid_attrs)
      assert drawing.drawing == "some drawing"
    end

    test "create_drawing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Retros.create_drawing(@invalid_attrs)
    end

    test "update_drawing/2 with valid data updates the drawing" do
      drawing = drawing_fixture()
      assert {:ok, %Drawing{} = drawing} = Retros.update_drawing(drawing, @update_attrs)
      assert drawing.drawing == "some updated drawing"
    end

    test "update_drawing/2 with invalid data returns error changeset" do
      drawing = drawing_fixture()
      assert {:error, %Ecto.Changeset{}} = Retros.update_drawing(drawing, @invalid_attrs)
      assert drawing == Retros.get_drawing!(drawing.id)
    end

    test "delete_drawing/1 deletes the drawing" do
      drawing = drawing_fixture()
      assert {:ok, %Drawing{}} = Retros.delete_drawing(drawing)
      assert_raise Ecto.NoResultsError, fn -> Retros.get_drawing!(drawing.id) end
    end

    test "change_drawing/1 returns a drawing changeset" do
      drawing = drawing_fixture()
      assert %Ecto.Changeset{} = Retros.change_drawing(drawing)
    end
  end

  describe "boards" do
    alias FunRetro.Retros.Board

    @valid_attrs %{lanes: [], name: "some name"}
    @update_attrs %{lanes: [], name: "some updated name"}
    @invalid_attrs %{lanes: nil, name: nil}

    def board_fixture(attrs \\ %{}) do
      {:ok, board} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Retros.create_board()

      board
    end

    test "list_boards/0 returns all boards" do
      board = board_fixture()
      assert Retros.list_boards() == [board]
    end

    test "get_board!/1 returns the board with given id" do
      board = board_fixture()
      assert Retros.get_board!(board.id) == board
    end

    test "create_board/1 with valid data creates a board" do
      assert {:ok, %Board{} = board} = Retros.create_board(@valid_attrs)
      assert board.lanes == []
      assert board.name == "some name"
    end

    test "create_board/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Retros.create_board(@invalid_attrs)
    end

    test "update_board/2 with valid data updates the board" do
      board = board_fixture()
      assert {:ok, %Board{} = board} = Retros.update_board(board, @update_attrs)
      assert board.lanes == []
      assert board.name == "some updated name"
    end

    test "update_board/2 with invalid data returns error changeset" do
      board = board_fixture()
      assert {:error, %Ecto.Changeset{}} = Retros.update_board(board, @invalid_attrs)
      assert board == Retros.get_board!(board.id)
    end

    test "delete_board/1 deletes the board" do
      board = board_fixture()
      assert {:ok, %Board{}} = Retros.delete_board(board)
      assert_raise Ecto.NoResultsError, fn -> Retros.get_board!(board.id) end
    end

    test "change_board/1 returns a board changeset" do
      board = board_fixture()
      assert %Ecto.Changeset{} = Retros.change_board(board)
    end
  end
end
