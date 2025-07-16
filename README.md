# CustomCommands

This project was designed to offer a quick and easy way to generate nearly identical `mix` tasks as well as shell commands for an Elixir project deployed to some system. By following the documented pattern, every function available in a provided file will be made into both a `mix task` as well as a shell script ready for deployment on a system.

```shell
mix my_new_task "hello world"
./my_new_task "hello world"
```

When building software many teams seek to have a similar set of commands available in their dev environment as they do in their production software. Elixir offers out of the box, `Mix` a tool that does all of the hard work in managing a project from dependency management to building a release file. Mix also makes custom commands available in a system called `mix tasks`, which are easily made and used by developers. However, `Mix` is not meant to be deployed on a target system, and invoking a `mix task` in "production" is not considered best practice. 

To bridge that gap, Elixir documentation reccomends building shell scripts that invoke functions inside of the executable. This project templates these files and upon running the new `mix task` documented below, `mix gen.commands`, those new commands become available as mix tasks immediately, and upon running `mix release` those commands become available in your target build directory. 

This is a demo project to show how you can quickly generate identical mix and command line scripts ready for use with your project.

### Set Up

After cloning this project, make sure the dependencies are available:

```shell
mix deps.get
```

Now you should be ready to play with how this demo works. 

### Demo

First generate the files for releases and mix tasks, and generate a release:
```shell 
MIX_ENV=prod mix release
```
ALTERNATIVELY, you may invoke the following command, and not generate a release:
```shell
mix gen.commands
```

The `mix gen.commands` task will generate 3 shell scripts in `rel/overlays` and 3 `.ex` files in `lib/mix/tasks`. This task is invoked during the `mix release` process, prior to running the Elixir provided `mix release` task.

Additionally, during the process that builds the release artifact the overlay `.sh` files will also be moved into `_build/prod/rel/custom_commands`

```
_build/prod/rel/custom_commands/
|-- bin/
|-- erts-15.2.3/
|-- lib/
|-- releases/
|-- add.sh
|-- divide_by_2.sh
`-- hello.sh
lib/mix/tasks/
|-- add.ex
|-- divide_by_2.ex
`-- hello.ex
rel/overlays/
|-- add.sh
|-- divide_by_2.sh
`-- hello.sh
```

#### Testing each

##### Hello
```shell
#  project root
mix hello
cd _build/prod/rel/custom_commands
./hello.sh 
```
##### Addition
```shell
#  project root
mix add --left=2 --right=3
cd _build/prod/rel/custom_commands
./add.sh --left=2 --right=3
```
##### Division
```shell
#  project root
mix divide_by_2 --dividend=24
cd _build/prod/rel/custom_commands
./divide_by_2.sh --dividend=24
```
### How does this work
`Sourceror` is used to read a hardcoded file path `lib/custom_commands/release.ex`, and find all of the public functions defined. Each of those function names are then given to a list of templates that conduct find and replace activities. The templates are available at `priv/templates` and do not take advantage of Elixir's built in templating system. 

The ability to generate these every time you run `mix compile` or `mix release` is achieved with an alias function in `mix.exs` like so:
```elixir
defp aliases do
    [
      compile: ["gen.commands", "compile"],
      release: ["gen.commands", "release"]
    ]
end
```

### Extending this
To take full advantage of the pattern, all you must do is add public functions to `lib/custom_commands/release.ex`. Feel free to bring this into your project and take full advantage of making this available. 

### Future Considerations
I may republish this in the future with a full mix task created for download and use in your project with a larger test suite when I have more time available to dedicate. 

### Resources
- I wrote about this on my substack at [jcasey-tech](https://jcaseytech.substack.com/p/custom-commands-in-elixir) which goes into detail on the reasoning I went through to go through this process and how I came to the current solution
- Phoenix Framework gave me the idea for custom commands in the first place, and you should read [their guide on migrations and custom commands](https://hexdocs.pm/phoenix/releases.html#ecto-migrations-and-custom-commands).
- While reading about Phoenix, check out fly.io's [guide on how database migrations work](https://fly.io/phoenix-files/how-to-migrate-mix-release-projects/), and the types of inputs they manage
- Read up on [how mix release works](https://hexdocs.pm/mix/Mix.Tasks.Release.html) from the Elixir language team 

Copyright John Casey(@caseyj) 2025
