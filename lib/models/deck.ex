defmodule Deck do
  def create_doors() do

    numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    awards = ["X", "X", "X", 50, 100, 200, 0, 0, 0, 0]

    # Desordena la lista de números

    #Enum.shuffle(numbers)

    # Combinamos las listas de numbers y awards para generar una tupla

    numbers |> Enum.zip(awards)

    # Creamos una nueva lista a partir de la tupla tomando cada número y premio

    |> Enum.map(fn {number, award} -> %Door{name: number, award: award} end)

    # Ordenamos la lista tomando como referencia el número

    |> Enum.sort(fn (%Door{ name: name1 }, %Door{ name: name2 }) -> name1 < name2 end)

    # Creamos una nueva lista de door a partir de la lista anterior

    |> Enum.map(fn(door) ->
      %{door | name: "P#{door.name}"}
    end)

  end
end
