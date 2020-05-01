defmodule FunRetro.Repo do
  use Ecto.Repo,
    otp_app: :fun_retro,
    adapter: Ecto.Adapters.Postgres
end
