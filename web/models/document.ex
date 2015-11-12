defmodule DocumentSearch.Document do
  use DocumentSearch.Web, :model

  schema "documents" do
    field :title, :string
    field :content, :string

    timestamps
  end

  @required_fields ~w(title content)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def full_text_search(base_query, searching_query) do
    from d in base_query,
    where: fragment("content @@ ?", ^searching_query)
  end
end
