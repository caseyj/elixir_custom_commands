defmodule Addition do


  def add(args) do
    {parsed, _, _} = OptionParser.parse(args, strict: [
      left: :integer,
      right: :integer
    ])
    IO.puts("#{parsed[:left] + parsed[:right]}")
  end

end
