defmodule FunRetroWeb.DrawingController do
  use FunRetroWeb, :controller

  alias FunRetro.Retros
  alias FunRetro.Retros.Drawing
  alias FunRetro.Retros.LiveUpdates

  plug :authenticate

  def index(conn, params) do
    drawings = Retros.list_drawings(params["board_id"])
    render(conn, "index.html", drawings: drawings, board_id: params["board_id"])
  end

  def new(conn, params) do
    changeset = Retros.change_drawing(%Drawing{})
    board_id = params["board_id"]

    render(conn, "new.html",
      changeset: changeset,
      board_id: board_id,
      lanes: Retros.get_lanes_board!(board_id)
    )
  end

  def create(conn, %{"drawing" => drawing_params, "board_id" => board_id}) do
    case Retros.create_drawing(Map.put(drawing_params, "board_id", board_id)) do
      {:ok, drawing} ->
        LiveUpdates.notify_live_view(board_id, board_id)

        conn
        |> put_flash(:info, "Drawing created successfully.")
        |> redirect(to: Routes.board_path(conn, :show, drawing.board_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html",
          board_id: board_id,
          changeset: changeset,
          lanes: Retros.get_lanes_board!(board_id)
        )
    end
  end

  def show(conn, %{"id" => id}) do
    drawing = Retros.get_drawing!(id)
    render(conn, "show.html", drawing: drawing)
  end

  def edit(conn, %{"id" => id, "board_id" => board_id}) do
    drawing = Retros.get_drawing!(id)
    changeset = Retros.change_drawing(drawing)

    render(conn, "edit.html",
      drawing: drawing,
      changeset: changeset,
      lanes: Retros.get_lanes_board!(board_id)
    )
  end

  def update(conn, %{"id" => id, "drawing" => drawing_params}) do
    drawing = Retros.get_drawing!(id)

    case Retros.update_drawing(drawing, drawing_params) do
      {:ok, drawing} ->
        LiveUpdates.notify_live_view(drawing.board_id, drawing.board_id)

        conn
        |> put_flash(:info, "Drawing updated successfully.")
        |> redirect(to: Routes.board_path(conn, :show, drawing.board_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          drawing: drawing,
          changeset: changeset,
          lanes: Retros.get_lanes_board!(drawing.board_id)
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    drawing = Retros.get_drawing!(id)
    {:ok, _drawing} = Retros.delete_drawing(drawing)
    LiveUpdates.notify_live_view(drawing.board_id, drawing.board_id)

    conn
    |> put_flash(:info, "Drawing deleted successfully.")
    |> redirect(to: Routes.board_path(conn, :show, drawing.board_id))
  end

  defp authenticate(%{params: %{"board_id" => board_id}} = conn, _opts) do
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
