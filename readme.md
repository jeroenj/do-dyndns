# Readme
## Usage
Generate an application token and pass it by using the `DIGITALOCEAN_ACCESS_TOKEN` environment variable. Domain and record are the options passed to the script.

First run `bundle install` to install the dependencies.

Afterwards run:

```
DIGITAL_OCEAN_TOKEN=secret ruby dns.rb domain record
```
