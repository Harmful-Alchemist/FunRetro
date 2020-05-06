defmodule FunRetroWeb.Auth do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    board_id = get_session(conn, :board_id_auth)
    board = board_id && FunRetro.Retros.get_board_without_drawings!(board_id)
    assign(conn, :current_board, board)
  end

  def login(conn, board) do
    IO.inspect(conn)
    conn = update_in(conn.assigns, &Map.put(&1, :current_board, board))
    IO.inspect(conn)
    conn
#    |> assign(:current_board, board)
    |> put_session(:board_id_auth, board.id)
    |> configure_session(renew: true)
  end
end
