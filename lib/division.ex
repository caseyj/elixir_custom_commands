defmodule Division do


  def division_by_2(args) do
    {parsed, _, _} = OptionParser.parse(args, strict: [
      dividend: :integer
    ])
    IO.puts("#{parsed[:dividend] / 2}")
  end

end
