# Rsyslog mmnormalize rulebase

- rules that parse test lines into structured JSON
- guide at http://www.liblognorm.com/files/manual/configuration.html
- rules can be expressed in condensed or long (JSON) format, but if you need complex things, please
  use the JSON format

## Targets

- lmod (loads, commands)

# Tests

- requires the lognormaliser binary to be present in your PATH
    - git clone git@github.com:rsyslog/libfastjson.git and build it
    - git clone git@github.com:rsyslog/libestr.git and build it
    - git clone git@github.com:rsyslog/liblognorm.git and build it

- steps to install
    - cd libfastjson
    - autoreconf -vfi
    - ./configure --prefix=$PREFIX
    - make install
    - cd ../libestr
    - autoreconf -vfi
    - export PKG_CONFIG_PATH=$HOME/work/hpc/env/rsyslog-rulebase/lib/pkgconfig
    - ./configure --prefix=$PREFIX
    - make install
    - cd ../liblognorm
    - autoreconf -vfi
    - ./configure --prefix=$PREFIX
    - make install

    

