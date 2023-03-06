defmodule Door do

  defstruct name: "", award: :undefined, wasOpenned: false

  def new_door(name, award, wasOpenned) do
    %Door{name: name, award: award, wasOpenned: wasOpenned}
  end


end
