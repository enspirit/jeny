# Jeny

Jeny aims at being a simple yet powerful code generation and scaffolding
system.

## Command line

Jeny comes with a command line

```sh
jeny --help
```

### Generate a project from a scaffold

```sh
jeny -d ... -d ... generate path/to/scaffold path/to/target
```

### Generate code snippets on an existing project

```sh
jeny -d ... -d ... snippet snipname path/to/files
```

Code snippets are commented code blocks prefixed by a jeny delimiter.
When executing `jeny s`, all files under `path/to/files` are inspected
and jeny code blocks instantiated as uncommented code.

For instance, when executing

```sh
jeny -d name:hello snippet method .
```

the following code block...

```
#jeny(method) def ${name}
#jeny(method)   # TODO
#jeny(method) end
```

will become:

```
def hello
  # TODO
end
```

The `s[snippet]` command is also able to generate fresh new files,
provided they end with `.jeny` and have a clearly identified context.

For instance, a file called `test.rb.jeny` will be instantiated when
generating a `method` snippet if it contains the following header:

```
#jenycontext method
```

The full file path is also instantiated through variables before the
file is created. Naming the file `test__name_.rb.jeny` will generate
`test_hello.rb`.

## Configuration and available options

Jeny behavior can be tuned in three different ways (by ascending order of
priority): environment variables, a .jeny configuration file, and command
line options.

For full details, please check the documentation of `Jeny::Configuration`.

### Environment variables

* `JENY_EDITOR`, `GIT_EDITOR`, `EDITOR` are inspected in that order to
  find which source code editor to use

* `JENY_STATE_MANAGER=none|git` is used to know which state manager to
  use. See `Jeny::StateManager`

### .jeny configuration file

At start `jeny` looks for a `.jeny` configuration file in the current
folder and all ancestors, and uses it to override default configuration
infered from environment variables.

```
Jeny::Configuration.new do |c|
  # c is a Jeny::Configuration instance
  #
  # many accessors are available for options
end
```

### Commandline options

Options passed on the commandline always override the configuration
obtained through environment variables and the .jeny file.

For a full list of options, check the help:

```
jeny --help
```

## Licence

This software is distributed by Enspirit SRL under a MIT Licence. Please
contact Bernard Lambeau (blambeau@gmail.com) with any question.
