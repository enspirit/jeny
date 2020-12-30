# Jeny

Jeny is a simple yet powerful commandline tool for scaffolding new
projects and generating code snippets in existing ones.

```sh
jeny --help
```

The outline of this readme is as follows:

- Two use cases: scaffolding & snippets
- The templating language
- How do I generate dynamic file names?
- Use `--git` for atomic generation of snippets
- Configuring `jeny`: env vars, .jeny file and commandline options
- Contributing, Licence, etc.

## Generate a project from a scaffold

The first use case is the generation of a project structure from
an existing scaffold.

```sh
jeny -d ... -d ... generate path/to/scaffold path/to/target
```

This command will recursively copy and instantiate files and
directories from the scaffold folder to the destination folder.

File content is generated using a very simple and not that
powerful templating language, see sections later. Code snippets
of the following section are NOT supported for now.

## Generate code snippets on an existing project

The second use case is the generation of code snippets inside
existing annotated source code.

```sh
jeny -d ... -d ... snippet snipname path/to/code
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

... will generate the code below in the file where it is found,
while preserving the jeny code block for subsequent calls:

```
def hello
  # TODO
end
```

The `s[snippet]` command is also able to generate fresh new files,
provided they end with `.jeny` and have a clearly snippet identifier
as first line. For instance, a file called `test.rb.jeny` will be
instantiated when  generating a `method` snippet if it contains the
following first line:

```
#jeny(method)
```

## Templating language

The current template language uses (WLang)[https://github.com/blambeau/wlang]
with a very simple dialect. Jeny only supports simple variable for now. It
does not support iterations and conditionals, on intent (?).

Let's say you specify a `-d op_name:my_method` commandline option, the
following casing tags are recognized:

```
${op_name}     ->    my_method   (snake)
${opname}      ->    mymethod    (flat)
${opName}      ->    myMethod    (camel)
${OpName}      ->    MyMethod    (pascal)
${OP_NAME}     ->    MY_METHOD   (screaming)
${OP NAME}     ->    MYMETHOD    (upper)
${OPNAME}      ->    MYMETHOD    (upper flat)
${op-name}     ->    my-method   (kebab)
${Op-Name}     ->    My-Method   (header)
${OP-NAME}     ->    MY-METHOD   (cobol)
${OP|NAME}     ->    MY|METHOD   (donner)
```

## Dynamic file names

If you need generated file name names (and/or ancestor folders), you can use
the very same tags as those documented in previous section.

* In scaffolding mode, all files can have dynamic names.
* In snippets mode, only files with a `.jeny` ext can.

## Atomic snippets generation

The `--git` commandline option (or equivalent configuration, see section
below) can be used to generate snippets in an atomic way.

```sh
jeny --git -d ... s snipname
```

Doing so will:
- stash any current change
- generate code snippets
- commit the result
- unstash stashed changes

If anything fails, all changes are reverted before unstashing.

**IMPORTANT** You must execute `jeny` with a git project as current folder.

**IMPORTANT** Please use this option with case, as it is still experimental.

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

## Contributing

use github issues and pull requests for contributions. Please favor pull
requests if possible for small changes. Make sure to keep in touch with us
before making big changes though, as they might not be aligned with our
roadmap, or conflict with open pull requests.

## Licence

This software is distributed by Enspirit SRL under a MIT Licence. Please
contact Bernard Lambeau (blambeau@gmail.com) with any question.
