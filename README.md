# Fukuzatsu

Fukuzatsu (Japanese for "complexity") is a tool for measuring code complexity in Ruby class files. Its analysis
generates scores based on cyclomatic complexity algorithms, which in simplest terms measure the number of execution paths through a given piece of code. (You can learn more about cyclomatic complexity [here](http://en.wikipedia.org/wiki/Cyclomatic_complexity).)

Why should you care about this kind of complexity? More complex code tends to attract bugs and to
increase the friction around extending features or refactoring code.

Fukuzatsu was created by [Coraline Ada Ehmke](http://where.coraline.codes/) and is maintained by [Coraline Ada Ehmke](http://where.coraline.codes/), [Mike Ziwisky](https://github.com/mziwisky), and the team at [Instructure](http://www.instructure.com/). It was originally inspired by Saikuro, written by Zev Blut.

## Screenshots

These are screenshots of the `-f html` output. First, the overall project summary:

![Project Summary](https://gitlab.com/coraline/fukuzatsu/raw/master/doc/images/overview.png)

Then the detail view of a single class:

![Project Summary](https://gitlab.com/coraline/fukuzatsu/raw/master/doc/images/details.png)

## Installation

Install the gem:

    $ gem install fukuzatsu

This installs the CLI tool.

## Usage

    fuku check path/to/file/my_file.rb

    fuku check path/to/directory
    # Generates report for all rb files in the given directory

    fuku check path/to/file/my_file.rb -f html
    # Writes to doc/fuzuzatsu/htm/index.htm

    fuku check path/to/file/my_file.rb -f csv
    # Writes to doc/fuzuzatsu/csv/results.csv

    fuku check path/to/file/my_file.rb -f json
    # Writes to doc/fuzuzatsu/json/results.json

### Running as docker image

The following will download the latest docker image, mount the current directory inside the container and run `fuku check -f html .` which generates html report for all ruby files in the current directory.

    docker run -v $(pwd):/tmp/fuku --workdir=/tmp/fuku rubygem/fukuzatsu check -f html .


## Contributing

Please note that this project is released with a [Contributor Code of Conduct](http://contributor-covenant.org/version/1/0/0/). By participating in this project you agree to abide by its terms.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
