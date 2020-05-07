defmodule FunRetroWeb.PageControllerTest do
  use FunRetroWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to your digital flip chart"
  end
end
