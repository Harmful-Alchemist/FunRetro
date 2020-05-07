defmodule FunRetroWeb.BoardControllerTest do
  use FunRetroWeb.ConnCase

  use Plug.Test

  alias FunRetro.Retros

  @create_attrs %{lanes: ["lane 1", "lane 2"], name: "some name", password: "testpass1234"}
  @update_attrs %{lanes: ["lane 1", "lane 2"], name: "some updated name"}
  @invalid_attrs %{lanes: nil, name: nil}

  def fixture(:board) do
    {:ok, board} = Retros.create_board(@create_attrs)
    board
  end

  #  describe "index" do
  #    test "lists all boards", %{conn: conn} do
  #      conn = get(conn, Routes.board_path(conn, :index))
  #      assert html_response(conn, 200) =~ "Listing Boards"
  #    end
  #  end

  describe "new board" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.board_path(conn, :new))
      assert html_response(conn, 200) =~ "New Board"
    end
  end

  describe "create board" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.board_path(conn, :create), board: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.board_path(conn, :show, id)

      conn = get(conn, Routes.board_path(conn, :show, id))
      assert html_response(conn, 200) =~ "data-phx-view=\"BoardLive\""
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.board_path(conn, :create), board: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Board"
    end
  end

  describe "edit board login" do
    setup [:create_board]

    test "redirects to login without authorization", %{conn: conn, board: board} do
      conn = get(conn, Routes.board_path(conn, :edit, board))
      assert redirected_to(conn) == Routes.board_auth_path(conn, :new, board.id)
    end
  end

  describe "edit board" do
    setup [:create_board]

    test "renders form for editing chosen board", %{conn: conn, board: board} do
      conn =
        update_in(conn.assigns, &Map.put(&1, :current_board, board))
        |> Plug.Test.init_test_session(%{})
        |> put_session(:board_id_auth, board.id)
        |> configure_session(renew: true)

      conn = get(conn, Routes.board_path(conn, :edit, board))

      assert html_response(conn, 200) =~ "Edit Board"
    end
  end

  describe "update board" do
    setup [:create_board]

    test "redirects when data is valid", %{conn: conn, board: board} do
      conn =
        update_in(conn.assigns, &Map.put(&1, :current_board, board))
        |> Plug.Test.init_test_session(%{})
        |> put_session(:board_id_auth, board.id)
        |> configure_session(renew: true)
        |> put(Routes.board_path(conn, :update, board), board: @update_attrs)

      assert redirected_to(conn) == Routes.board_path(conn, :show, board.id)

      conn = get(conn, Routes.board_path(conn, :show, board.id))
      assert html_response(conn, 200) =~ ""
    end

    test "renders errors when data is invalid", %{conn: conn, board: board} do
      conn =
        update_in(conn.assigns, &Map.put(&1, :current_board, board))
        |> Plug.Test.init_test_session(%{})
        |> put_session(:board_id_auth, board.id)
        |> configure_session(renew: true)

      conn = put(conn, Routes.board_path(conn, :update, board), board: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Board"
    end
  end

  #  describe "delete board" do
  #    setup [:create_board]
  #
  #    test "deletes chosen board", %{conn: conn, board: board} do
  #      conn = delete(conn, Routes.board_path(conn, :delete, board))
  #      assert redirected_to(conn) == Routes.board_path(conn, :index)
  #
  #      assert_error_sent 404, fn ->
  #        get(conn, Routes.board_path(conn, :show, board))
  #      end
  #    end
  #  end

  defp create_board(_) do
    board = fixture(:board)
    %{board: board}
  end
end
