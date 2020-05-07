defmodule FunRetroWeb.BoardLive do
  use Phoenix.LiveView, layout: {FunRetroWeb.LayoutView, "live.html"}

  alias FunRetro.Retros
  alias FunRetro.Retros.LiveUpdates

  def render(assigns) do
    Phoenix.View.render(FunRetroWeb.BoardView, "show.html", assigns)
  end

  def mount(_params, %{"id" => id}, socket) do
    LiveUpdates.subscribe_live_view(id)
    board = Retros.get_board!(id)
    {:ok, assign(socket, board: board)}
  end

  def handle_info(id, socket) do
    board = Retros.get_board!(id)
    {:noreply, assign(socket, :board, board)}
  end
end
