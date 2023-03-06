defmodule WizardGame do

  def init() do
    # ___________________________________________________________________________________

    # Creamos una lista de puertas
    deck = Deck.create_doors()

    # Creamos un número para la ronda
    round_number = 1

    # Mostrar intro
    show_intro(round_number)

    # Mostrar puertas
    IO.puts("")
    print_doors(deck)
    IO.puts("")

    # Le pide al usuario la primera opción
    IO.puts("")
    first_user_answer = ask_for_option() |> option_to_int()

    # Le indica que saco
    IO.puts("")
    first = Enum.at(deck, first_user_answer)
    IO.puts("Has obtenido: #{first.award}")

    # Le indica al usuario cual fue la puerta que selecciono
    IO.puts("")
    IO.puts("La puerta que seleccionaste fue la: #{first.name}")

    # "Actualizamos la puerta seleccionada"
    IO.puts("")
    new_door = Door.new_door(first.name, first.award, true)

    # "Actualizamos las puertas
    IO.puts("")
    new_deck = replace_door_by_name(deck, new_door)

    # Creamos la estructura player
    player = Player.new_player(1, [first.award])

    # Le muestra al usuario cuanto dinero tiene
    money_summary = sum_non_zeros(player.awards)
    validate_money_summary(money_summary)

    #Le muestra al usuario cuantas llantas tiene
    tires_summary = count_zeros(player.awards)
    validate_tires_summary(tires_summary)

    next_round(round_number, player, new_deck)




  end

  def validate_money_summary(money_summary) do
    cond do
      money_summary === 0 ->
        :ok
      money_summary > 0 ->
        IO.puts("Total acumulado: $#{money_summary}")
    end
  end

  def validate_tires_summary(tires_summary) do
    cond do
      tires_summary === 0 ->
        :ok
      tires_summary > 0 ->
        IO.puts("Llantas encontradas: #{tires_summary}")
    end
  end

  def show_intro(round_number) do
    IO.puts("  ")
    IO.puts("E L   C O N C U R S O   D E L   M A G O 🧙🔮✨")
    IO.puts("  ")
    IO.puts("Ronda número: #{round_number}")
    IO.puts("  ")
  end

  def ask_for_option() do
    input = IO.gets("Por favor, introduce una opción (P1-P10): ") |> String.trim() |> String.upcase()
    IO.puts(" ")
    case input do
      "P1" -> input
      "P2" -> input
      "P3" -> input
      "P4" -> input
      "P5" -> input
      "P6" -> input
      "P7" -> input
      "P8" -> input
      "P9" -> input
      "P10" -> input
      _ ->
        IO.puts("La opción ingresada no es válida.")
        IO.puts(" ")
        ask_for_option()
    end
  end


  def option_to_int(input) do
    case input do
      "P1" -> 0
      "P2" -> 1
      "P3" -> 2
      "P4" -> 3
      "P5" -> 4
      "P6" -> 5
      "P7" -> 6
      "P8" -> 7
      "P9" -> 8
      "P10" -> 9
      _ -> raise "El string de entrada no es válido"
    end
  end

  def next_round(round_number, player, doors) do

    # Aumenta el numero de la ronda
    new_round_number = round_number + 1

    show_intro(new_round_number)

    IO.puts("")
    print_doors(doors)
    IO.puts("")

     # Le pide al usuario la opción
     IO.puts("")
     user_answer = ask_for_option() |> option_to_int()

     # Le indica que saco
     IO.puts("")
     option = Enum.at(doors, user_answer)
     IO.puts("Has obtenido: ")
     IO.inspect option.award

    # Le indica al usuario cual fue la puerta que selecciono
     IO.puts("")
     IO.puts("La puerta que seleccionaste fue la:  número: #{option.name}")

     # "Actualizamos la puerta seleccionada"
     IO.puts("")
     new_door = Door.new_door(option.name, option.award, true)

     # "Actualizamos las puertas
     IO.puts("")
     new_deck = replace_door_by_name(doors, new_door)

     player_awards = [player.awards] ++ [new_door.award]
     flatter_player_awards =  List.flatten(player_awards)

    # Actualizamos la estructura player
    new_player = validate_player(option, player, flatter_player_awards)

    # Le muestra al usuario cuanto dinero tiene
    money_summary = sum_non_zeros(new_player.awards)
    validate_money_summary(money_summary)

    #Le muestra al usuario cuantas llantas tiene
    tires_summary = count_zeros(new_player.awards)
    validate_tires_summary(tires_summary)

    # Contamos el numero de errores del jugador y validamos intentos del jugador
    Enum.filter(new_player.awards, fn award -> award === "X" end) |> Enum.count() |> check_player_mistakes(new_player.awards)

    # validamos intentos del jugador
    check_player_attempts(new_player.attempts, new_player.awards, new_round_number, new_player, new_deck)


  end

  def check_player_mistakes(number_of_mistakes, awards) when number_of_mistakes >= 3 do
    IO.puts("")
    IO.puts("Tienes tres errores, no puedes seguir jugando")
    IO.puts("")
    ganancias(awards)
    System.halt(0)
  end

  def check_player_mistakes(number_of_mistakes, _awards) when number_of_mistakes === 1  do
    IO.puts("")
    IO.puts("Tienes #{number_of_mistakes} error")
    IO.puts("")
  end

  def check_player_mistakes(number_of_mistakes, _awards)  do
    IO.puts("")
    IO.puts("Tienes #{number_of_mistakes} errores")
    IO.puts("")
  end

  def check_player_attempts(attempt, awards, round_number, player, deck)do

    if(attempt >= 6)do
      IO.puts("")
      IO.puts("Has utilizado tus 6 intentos, no puedes seguir jugando")
      IO.puts("")
      IO.puts("Las puertas reveladas son: ")
      IO.puts("")
      IO.inspect deck
      IO.puts("")
      ganancias(awards)
    else
      next_round(round_number, player, deck)
    end

  end

  def validate_player(door, player, flatter_player_awards) do
    if(door.wasOpenned === true) do
      Player.new_player(player.attempts + 1, player.awards)
    else
      Player.new_player(player.attempts + 1, flatter_player_awards)
    end
  end

  def replace_door_by_name(door_list, door_instance) do
    door_name = door_instance.name
    Enum.map(door_list, fn door ->
      if door.name == door_name do
        door_instance
      else
        door
      end
    end)
  end

  def print_doors(doors) do
    doors_strings = doors
      |> Enum.map(fn door ->
        if door.wasOpenned do
          "#{door.award}"
        else
          "#{door.name}"
        end
      end)

    IO.puts(Enum.join(doors_strings, " | "))
  end

  def ganancias(awards) do
    case {count_zeros(awards), sum_non_zeros(awards)} do
      {4, 0} -> IO.puts("--------------------------------------\n\nHas ganado un auto 🚗\n")
      {0, 0} -> IO.puts("--------------------------------------\n\nNo has ganado nada 😔\n")
      {0, total} -> IO.puts("--------------------------------------\n\nHas ganado: #{total}\n")
      {4, total} -> IO.puts("--------------------------------------\n\nHas ganado: #{total} y un auto 🚗\n")
      {_, total} -> IO.puts("--------------------------------------\n\nHas ganado: #{total}\n")
    end
  end

  defp count_zeros(awards) do
    awards |> Enum.filter(fn award -> award === 0 end)
    |> Enum.count()
  end

  defp sum_non_zeros(awards) do
    awards |> Enum.filter(fn award -> award !== 0 and Kernel.is_integer(award) end)
    |> Enum.sum()
  end



end
