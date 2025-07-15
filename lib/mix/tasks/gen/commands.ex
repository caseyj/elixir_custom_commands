defmodule Mix.Tasks.Gen.Commands do
  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    Code.compile_file("scripts/code_generation_utils.exs")
    commands = CodeGenerationUtils.generate_files_and_commands()
    file = "#{inspect(commands)}"
    File.write("config/commands.exs", file)
  end
end
