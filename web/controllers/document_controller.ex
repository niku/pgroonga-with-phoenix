defmodule DocumentSearch.DocumentController do
  use DocumentSearch.Web, :controller

  alias DocumentSearch.Document

  plug :scrub_params, "document" when action in [:create, :update]

  def index(conn, %{"document" => %{"query" => query}}) do
    documents = Repo.all(Document.full_text_search(Document, query))
    render(conn, "index.html", documents: documents)
  end

  def index(conn, _params) do
    documents = Repo.all(Document)
    render(conn, "index.html", documents: documents)
  end

  def new(conn, _params) do
    changeset = Document.changeset(%Document{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"document" => document_params}) do
    changeset = Document.changeset(%Document{}, document_params)

    case Repo.insert(changeset) do
      {:ok, _document} ->
        conn
        |> put_flash(:info, "Document created successfully.")
        |> redirect(to: document_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    document = Repo.get!(Document, id)
    render(conn, "show.html", document: document)
  end

  def edit(conn, %{"id" => id}) do
    document = Repo.get!(Document, id)
    changeset = Document.changeset(document)
    render(conn, "edit.html", document: document, changeset: changeset)
  end

  def update(conn, %{"id" => id, "document" => document_params}) do
    document = Repo.get!(Document, id)
    changeset = Document.changeset(document, document_params)

    case Repo.update(changeset) do
      {:ok, document} ->
        conn
        |> put_flash(:info, "Document updated successfully.")
        |> redirect(to: document_path(conn, :show, document))
      {:error, changeset} ->
        render(conn, "edit.html", document: document, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    document = Repo.get!(Document, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(document)

    conn
    |> put_flash(:info, "Document deleted successfully.")
    |> redirect(to: document_path(conn, :index))
  end
end
