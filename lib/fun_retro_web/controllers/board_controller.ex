defmodule FunRetroWeb.BoardController do
  use FunRetroWeb, :controller

  alias FunRetro.Retros
  alias FunRetro.Retros.Board
  alias FunRetro.Retros.LiveUpdates
  alias FunRetroWeb.BoardLive

  plug :authenticate when action in [:show, :edit, :update, :delete]

  def index(conn, _params) do
    boards = Retros.list_boards()
    render(conn, "index.html", boards: boards)
  end

  def new(conn, _params) do
    changeset = Retros.change_registration(%Board{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"board" => board_params}) do
    case Retros.register_board(board_params) do
      {:ok, board} ->
        conn
        |> FunRetroWeb.Auth.login(board)
        |> put_flash(:info, "Board created successfully.")
        |> redirect(to: Routes.board_path(conn, :show, board))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, params) do
    #    redirect(conn,
    #      to: Routes.live_path(FunRetroWeb.Endpoint, FunRetroWeb.BoardLive, %Board{id: id})
    #    )
    IO.inspect(params)
    live_render(conn, BoardLive, session: params)
  end

  def edit(conn, %{"id" => id}) do
    board = Retros.get_board!(id)
    changeset = Retros.change_board(board)
    render(conn, "edit.html", board: board, changeset: changeset)
  end

  def update(conn, %{"id" => id, "board" => board_params}) do
    board = Retros.get_board!(id)

    case Retros.update_board(board, board_params) do
      {:ok, board} ->
        LiveUpdates.notify_live_view(board.id, board.id)

        conn
        |> put_flash(:info, "Board updated successfully.")
        |> redirect(to: Routes.board_path(conn, :show, board))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", board: board, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    board = Retros.get_board!(id)
    {:ok, _board} = Retros.delete_board(board)

    conn
    |> put_flash(:info, "Board deleted successfully.")
    |> redirect(to: Routes.board_path(conn, :index))
  end

  defp authenticate(%{params: %{"id" => board_id}} = conn, _opts) do
    IO.puts("hellooooooooo")
    IO.inspect(conn)
    if conn.assigns.current_board && "#{conn.assigns.current_board.id}" == board_id do
      conn
    else
      conn
      |> put_flash(
        :error,
        "You must be have access to this board please authenticate with a password"
      )
      |> redirect(to: Routes.board_auth_path(conn, :new, board_id))
      |> halt()
    end
  end
end
