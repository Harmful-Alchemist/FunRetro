defmodule FunRetroWeb.DrawingControllerTest do
  use FunRetroWeb.ConnCase

  alias FunRetro.Retros

  @create_attrs %{drawing: "some drawing", lane: "lane 1"}
  @create_board_attrs %{lanes: ["lane 1", "lane 2"], name: "some name", password: "testpass1234"}
  @update_attrs %{drawing: "some updated drawing"}
  @invalid_attrs %{drawing: nil}

  def fixture(:drawing, board_id) do
    {:ok, drawing} = Retros.create_drawing(Map.put(@create_attrs, :board_id, board_id))
    drawing
  end

  def fixture(:board) do
    {:ok, board} = Retros.create_board(@create_board_attrs)
    board
  end

  #  describe "index" do
  #    test "lists all drawings", %{conn: conn} do
  #      conn = get(conn, Routes.board_drawing_path(conn, :index))
  #      assert html_response(conn, 200) =~ "Listing Drawings"
  #    end
  #  end

  describe "new drawing" do
    setup [:create_drawing]

    test "renders form", %{conn: conn, board: board} do
      conn = authenticate(conn, board)
      conn = get(conn, Routes.board_drawing_path(conn, :new, board.id))
      assert html_response(conn, 200) =~ "New Drawing"
    end
  end

  describe "create drawing" do
    setup [:create_drawing]

    test "redirects to show when data is valid", %{conn: conn, board: board} do
      conn = authenticate(conn, board)

      conn =
        post(conn, Routes.board_drawing_path(conn, :create, board.id), drawing: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.board_path(conn, :show, board.id)
    end

    test "renders errors when data is invalid", %{conn: conn, board: board} do
      conn = authenticate(conn, board)

      conn =
        post(conn, Routes.board_drawing_path(conn, :create, board.id), drawing: @invalid_attrs)

      assert html_response(conn, 200) =~ "New Drawing"
    end
  end

  describe "edit drawing" do
    setup [:create_drawing]

    test "renders form for editing chosen drawing", %{conn: conn, drawing: drawing, board: board} do
      conn = authenticate(conn, board)

      conn = get(conn, Routes.board_drawing_path(conn, :edit, board.id, drawing))
      assert html_response(conn, 200) =~ "Edit Drawing"
    end
  end

  describe "update drawing" do
    setup [:create_drawing]

    test "redirects when data is valid", %{conn: conn, drawing: drawing, board: board} do
      conn = authenticate(conn, board)

      conn =
        put(conn, Routes.board_drawing_path(conn, :update, board.id, drawing),
          drawing: @update_attrs
        )

      assert redirected_to(conn) == Routes.board_path(conn, :show, board.id)
    end

    test "renders errors when data is invalid", %{conn: conn, drawing: drawing, board: board} do
      conn = authenticate(conn, board)

      conn =
        put(conn, Routes.board_drawing_path(conn, :update, board.id, drawing.id),
          board: board,
          drawing: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Drawing"
    end
  end

  describe "delete drawing" do
    setup [:create_drawing]

    test "deletes chosen drawing", %{conn: conn, drawing: drawing, board: board} do
      conn = authenticate(conn, board)

      conn = delete(conn, Routes.board_drawing_path(conn, :delete, board.id, drawing))
      assert redirected_to(conn) == Routes.board_path(conn, :show, board.id)

      assert_error_sent 404, fn ->
        get(conn, Routes.board_drawing_path(conn, :show, board.id, drawing))
      end
    end
  end

  defp create_drawing(_) do
    board = fixture(:board)
    drawing = fixture(:drawing, board.id)
    %{drawing: drawing, board: board}
  end

  defp authenticate(conn, board) do
    update_in(conn.assigns, &Map.put(&1, :current_board, board))
    |> Plug.Test.init_test_session(%{})
    |> put_session(:board_id_auth, board.id)
    |> configure_session(renew: true)
  end
end
