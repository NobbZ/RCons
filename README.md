# RCons

TODO: Write a gem description

## Installation

Just install via rubygems:

```bash
$ gem install RCons
```

## Usage

Have a <tt>RConstruct.rb`, `RConsFile.rb`, `RConstruct`, or `RConsFile</tt> in your
sourcefolder and invoke RCons:

```bash
$ rcons
```

This will compile everything needed for the target `graph`.

Also you can invoke RCons with other options:

```bash
$ rcons help
Commands:
  rcons graph           # Draws the dependency graph
  rcons help [COMMAND]  # Describe available commands or one specific command

Options:
  [--log=<loglevel>]  # Sets the log level
                      # Default: 1
```


## Todo

* The target `all` doesn't do a thing at the moment, this has to be changed
* More windows support

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
