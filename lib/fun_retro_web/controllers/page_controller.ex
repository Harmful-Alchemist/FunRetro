defmodule FunRetroWeb.PageController do
  use FunRetroWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
