defmodule Swerve.Repo do
  use Ecto.Repo,
    otp_app: :swerve,
    adapter: Ecto.Adapters.Postgres
end
