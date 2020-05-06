defmodule FunRetroWeb.AuthController do
  use FunRetroWeb, :controller

  def new(conn, %{"board_id" => board_id}) do
    render(conn, "new.html", board_id: board_id)
  end

  def create(conn, %{"board_id" => board_id, "session" => %{"password" => pass}}) do
    IO.inspect(board_id)
    case FunRetro.Retros.authenticate_board(board_id, pass) do
      {:ok, board} ->
        conn
        |> FunRetroWeb.Auth.login(board)
        |> redirect(to: Routes.board_path(conn, :show, board_id))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid password")
        |> render("new.html", board_id: board_id)
    end
  end
end
