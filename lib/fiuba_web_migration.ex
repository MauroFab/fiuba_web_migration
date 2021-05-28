defmodule FiubaWebMigration do
  @moduledoc """
  Documentation for `FiubaWebMigration`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> FiubaWebMigration.hello()
      :world

  """
  def hello do
    :world
  end


  def noticias_migration do

    alias FiubaWebMigration.Repo
    import Ecto.Query

    {:ok, respuesta} = Repo.query("
      SELECT
          node.nid as NODO,
          node.title as TITULO,
          field_data_field_date.field_date_value AS FECHA,
          field_data_body.body_value as TEXTO,
          REPLACE (file_managed.uri,'public://','www.fi.uba.ar/sites/default/files/') AS PORTADA
      FROM node
      INNER JOIN field_data_body ON  node.nid = field_data_body.entity_id
      LEFT JOIN field_data_field_date ON node.nid = field_data_field_date.entity_id
      LEFT JOIN field_data_field_image ON (node.nid = field_data_field_image.entity_id AND field_data_field_image.bundle = 'article')
      LEFT JOIN file_managed ON field_data_field_image.field_image_fid = file_managed.fid
      WHERE node.type = 'article'
      ORDER BY node.title
      ")

    noticias = respuesta.rows

    Enum.map(noticias,
      fn elemento ->

        noticia = %{
          "titulo" => Enum.at(elemento,1),
          "fecha" => Enum.at(elemento,2),
          "cuerpo" => Enum.at(elemento,3)}

        ##Aca tiene que venir el post

      end)
  end
end
