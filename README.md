# Decidim::DecidimappK8s

Manage DecidimApp application to run on Kubernetes cluster.

## Usage

This engine contains library to manage creation and update of decidim instances.

It adds a new rake task : 

> bundle exec rake decidim_app:k8s:external_install_or_reload path=./spec/fixtures/with_extra_admins.yml verbose=y

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-decidimapp_k8s"
```

And then execute:

```bash
bundle
```

## Requirements

* Decidim application : v0.27.x

## Getting started

* See examples documentation : [examples](./docs/examples.md)

## Contributing

See [Decidim](https://github.com/decidim/decidim).

## License

This engine is distributed under the GNU AFFERO GENERAL PUBLIC LICENSE.
