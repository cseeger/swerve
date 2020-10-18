defmodule Swerve.Links do
  @moduledoc """
  The Links context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Swerve.Repo
  alias Ecto.Multi
  alias Swerve.Links.Link

  @doc """
  Returns the list of links.

  ## Examples

      iex> list_links()
      [%Link{}, ...]

  """
  def list_links do
    Repo.all(Link)
  end

  @doc """
  Gets a single link.

  Raises `Ecto.NoResultsError` if the Link does not exist.

  ## Examples

      iex> get_link!(123)
      %Link{}

      iex> get_link!(456)
      ** (Ecto.NoResultsError)

  """
  def get_link!(id), do: Repo.get!(Link, id)

  @doc """
  Creates a link.

  ## Examples

      iex> create_link(%{field: value})
      {:ok, %Link{}}

      iex> create_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_link(attrs \\ %{}) do
    multi =
      Multi.new()
      |> Multi.insert(:link_insert, Link.changeset(%Link{}, attrs))
      |> Multi.run(:link_final, fn repo, %{link_insert: link} ->
        base62_url = Base62.encode(link.id)
        changeset = change(link, base62_url: base62_url)
        repo.update(changeset)
      end)

    case Repo.transaction(multi, returning: true) do
      {:ok, result} -> {:ok, result[:link_final]}
      {:error, _, failed_value, _} -> {:error, failed_value}
    end
  end

  @doc """
   Updates a link.

   ## Examples

       iex> update_link(link, %{field: new_value})
       {:ok, %Link{}}

       iex> update_link(link, %{field: bad_value})
       {:error, %Ecto.Changeset{}}

  """
  def update_link(%Link{} = link, attrs) do
    link
    |> Link.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a link.

  ## Examples

      iex> delete_link(link)
      {:ok, %Link{}}

      iex> delete_link(link)
      {:error, %Ecto.Changeset{}}

  """
  def delete_link(%Link{} = link) do
    Repo.delete(link)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking link changes.

  ## Examples

      iex> change_link(link)
      %Ecto.Changeset{data: %Link{}}

  """
  def change_link(%Link{} = link, attrs \\ %{}) do
    Link.changeset(link, attrs)
  end

  @doc """
  Returns the Link via `base62_url`

  ## Examples

      iex> get_redirect!("abc")
      %Link{}

      iex> get_redirect!("zzzz")
      ** (Ecto.NoResultsError)

  """
  def get_redirect(base62_url) do
    Repo.get_by(Link, base62_url: base62_url)
  end
end
