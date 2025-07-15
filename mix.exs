defmodule CustomCommands.MixProject do
  use Mix.Project

  def project do
    [
      app: :custom_commands,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      releases: [
        custom_commands: [
          include_executables_for: [:unix]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [mod: {CustomCommands.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:sourceror, "~>1.10"}
    ]
  end

  defp aliases do
    [
      compile: ["gen.commands", "compile"],
      release: ["gen.commands", "release"]
    ]
  end
end
