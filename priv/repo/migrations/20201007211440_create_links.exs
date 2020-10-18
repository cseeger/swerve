defmodule Swerve.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :url, :string
      add :base62_url, :string

      timestamps()
    end
  end
end
