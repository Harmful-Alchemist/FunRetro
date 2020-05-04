defmodule FunRetroWeb.BoardLive do
  use Phoenix.LiveView
  use Phoenix.LiveView, layout: {GalleryWeb.LayoutView, "live.html"}

  alias FunRetro.Retros.Board
  alias FunRetro.Retros
  alias FunRetro.Retros.LiveUpdates

  def render(assigns) do
    Phoenix.View.render(FunRetroWeb.BoardView, "show.html", assigns)
  end

  def mount(%{"id" => id}, _session, socket) do
#    if connected?(socket), do: :timer.send_interval(3000, self(), :update)
    LiveUpdates.subscribe_live_view(id)
    board = Retros.get_board!(id)
    {:ok, assign(socket, board: board)}
  end

  def handle_info(id, socket) do
    IO.puts("yeah yeah")
    board = Retros.get_board!(id)
    {:noreply, assign(socket, :board, board)}
  end
end
