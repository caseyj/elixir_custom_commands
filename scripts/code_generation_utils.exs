defmodule CodeGenerationUtils do
  @moduledoc """
  Utility file that assists in generating templated shell scripts based on
  what functions are made available in a particular directory relative to the
  project root.
  """

  require Logger

  @doc """
  Helper function that will return the names of the functions available in the release file.
  """
  def get_task_names() do
    {:ok, code_file} = File.read("lib/custom_commands/release.ex") #this can probably be automated.
    {:ok, ast} = Sourceror.parse_string(code_file)
    # Recursively walk over the file collecting public function names
    Macro.prewalk(ast, [], fn
      {:def, _meta_def, [{name, _meta_name, _args} | _]} = node, acc ->
        {node, [name | acc]}

      # node must be passed incase we need to recurse through MANY layers of node
      # dont love this but its very gen purpose
      node, acc ->
        {node, acc}
    end)
    |> elem(1)
    #only give me the function names
  end

  def output_file_format(output_file_location, filename, extension \\ "sh") do
    "#{output_file_location}/#{filename}.#{extension}"
  end

  @doc """
  Replaces values in the file provided and writes to a new location or prints to stdout
  """
  def sed_file(filename, replacement_pairs, output_location \\ :stdout) do
    Logger.info("Attempting to find and replace for #{inspect(replacement_pairs)} in output location #{inspect(output_location)}")
    {:ok, file_data} = File.read(filename)
    n_data = String.replace(file_data, Map.keys(replacement_pairs), fn rep -> Map.get(replacement_pairs, rep) end, [global: true])
    case output_location do
      :stdout -> IO.puts("resembles:\n#{n_data}")
      _-> File.write(output_location, n_data)
      File.chmod!(output_location, 0o755)
    end
    Logger.info("Completed find and replace for #{inspect(replacement_pairs)}")
  end

  @doc """
  Generates files for a given set of task names generated by the parse function above.
  """
  def generate_task_files(template_filename, [task, task_camel] \\ ["{task}", "{task_camel}"], output_location \\ :stdout, extension \\ "sh") do
    Logger.info("Generating #{extension} files.")
    Enum.each(get_task_names(), fn elem ->
      stringed_elem = "#{elem}"
      module_name = Macro.camelize(stringed_elem)
      replacement_pairs = %{task=> stringed_elem, task_camel=> module_name}
      case output_location do
        :stdout -> sed_file(template_filename, replacement_pairs, :stdout)
        _-> sed_file(template_filename, replacement_pairs, output_file_format(output_location, elem, extension))
    end
    end)
    Logger.info("Completed generating  #{extension} files. They are viewable in #{output_location}")
  end

  @doc """
  Runs the whole show for command and file generation
  """
  def generate_files_and_commands() do
    #hard code here - config later
    generate_task_files("priv/templates/release_task.sh.txt", ["{task}", "{task_camel}"], "rel/overlays", "sh")
    generate_task_files("priv/templates/mix_task.ex.txt", ["{task}", "{task_camel}"], "lib/mix/tasks", "ex")
  end
end
