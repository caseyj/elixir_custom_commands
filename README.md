# CustomCommands

This shows off how I implemented custom commands for elixir projects such that they would be available in both releases and as mix tasks with little difference in how they are called.  
  
There are definitely some improvements that can be made, however this gives a pretty good starting place for a few patterns.

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

This command will generate 3 shell scripts in `rel/overlays` and 3 `.ex` files in `lib/mix/tasks`

Additionally, the process that builds the release artifact the overlay `.sh` files will also be moved into `_build/prod/rel/custom_commands`

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
### Extending this
To take full advantage of the pattern, all you must do is add public functions to `lib/custom_commands/release.ex`. Feel free to bring this into your project and take full advantage of making this available. 

### Resources
- I wrote about this on my substack at [jcasey-tech](https://jcaseytech.substack.com/p/custom-commands-in-elixir) which goes into detail on the reasoning I went through to go through this process and how I came to the current solution
- Phoenix Framework gave me the idea for custom commands in the first place, and you should read [their guide on migrations and custom commands](https://hexdocs.pm/phoenix/releases.html#ecto-migrations-and-custom-commands).
- While reading about Phoenix, check out fly.io's [guide on how database migrations work](https://fly.io/phoenix-files/how-to-migrate-mix-release-projects/), and the types of inputs they manage
- Read up on [how mix release works](https://hexdocs.pm/mix/Mix.Tasks.Release.html) from the Elixir language team 

Copyright John Casey(@caseyj) 2025
