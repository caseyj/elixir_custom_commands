defmodule CustomCommands.Release do

  def hello do
    Hello.hello(System.argv())
  end

  def add do
    Addition.add(System.argv())
  end

  def divide_by_2 do
    Division.division_by_2(System.argv())
  end

end
