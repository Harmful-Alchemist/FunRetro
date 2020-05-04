defmodule FunRetro.Retros.LiveUpdates do

  @doc "subscribe for specific board"
  def subscribe_live_view(board_id) do
    Phoenix.PubSub.subscribe(FunRetro.PubSub, to_string(board_id), link: true)
  end

    @doc "notify for specific board"
  def notify_live_view(board_id, board) do
    Phoenix.PubSub.broadcast(FunRetro.PubSub, to_string(board_id), board)
  end
end
