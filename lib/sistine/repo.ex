defmodule Sistine.Repo do
  use Ecto.Repo,
    otp_app: :sistine,
    adapter: Ecto.Adapters.Postgres
end
