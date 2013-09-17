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

This will compile everything needed for the target `all`.

Also you can invoke RCons with other options:

```bash
$ rcons [rcons options] <target name> [target options]
```

RCons understands the following options:

<dl>
  <di><tt>-l &lt;level&gt;</tt></di>
  <dd>The desired loglevel, defaults to <tt>-l 0</tt>
    <dl>
      <di><tt>-l 0</tt></di><dd>Debug, very verbose!</dd>
      <di><tt>-l 1</tt></di><dd>Info, puts out some information about the progress, recommended level!</dd>
      <di><tt>-l 2</tt></di><dd>Warn, only logs warnings, errors, and fatals.</dd>
      <di><tt>-l 3</tt></di><dd>Error, only errors and fatals.</dd>
      <di><tt>-l 4</tt></di><dd>Fatal, only really fatal errors will be logged</dd>
    </dl>
  </dd>
</dl>

Also there are the following built in targets:

<dl>
  <di><tt>all</tt></di><dd>Builts everything, but doesn't install anything into the system</dd>
  <di><tt>graph</tt></di>
  <dd>Creates a target-dependency-graph. The graph target knows about the
    following options:
    <dl>
      <di><tt>-o</tt>, <tt>--open</tt>, or <tt>--view</tt></di>
      <dd>Opens the generated graph after creating it (linux only via
        <tt>xdg-open</tt>)
      </dd>
    </dl>
  </dd>
</dl>

## Todo

* The target `all` doesn't do a thing at the moment, this has to be changed
* More windows support

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
