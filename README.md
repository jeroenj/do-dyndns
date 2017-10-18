# Readme
## Usage
### From source
Generate an application token and pass it by using the `DIGITALOCEAN_ACCESS_TOKEN` environment variable. Domain and record are the options passed to the script or can be set as the `DOMAIN` and `RECORD` environment variables.

First run `bundle install` to install the dependencies.

Afterwards run:

```
DIGITAL_OCEAN_TOKEN=secret ruby dns.rb domain record
```

### Using docker

```
docker run -e DIGITALOCEAN_ACCESS_TOKEN=secret -e DOMAIN=example.com -e RECORD= jeroenj/do-dyndns
```
