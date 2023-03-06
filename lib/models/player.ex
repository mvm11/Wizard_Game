defmodule Player do

  defstruct attempts: 0, awards: :undefined

  def new_player(attempts, awards) do
    %Player{attempts: attempts, awards: awards}
  end

end
