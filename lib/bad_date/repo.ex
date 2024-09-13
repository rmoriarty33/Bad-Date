defmodule BadDate.Repo do
  use Ecto.Repo,
    otp_app: :bad_date,
    adapter: Ecto.Adapters.SQLite3
end
