defmodule Migracion_carrera_especializacion do

  import Utils

  def menen() do
    especializaciones = cargar_carreras_especializacion()

    Enum.map(
      especializaciones,
      fn especializacion ->
        nodos_asociados =
          cargar_nodos_asociados_carreras_especializadas(Enum.at(especializacion, 1))

        Enum.map(
          nodos_asociados,
          fn nodo ->
            texto_nodo = cargar_texto_asociado(Enum.at(nodo, 1))
          end
        )
      end
    )
end


end
