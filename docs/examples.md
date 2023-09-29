# Create or update Decidim database

Based on provided configuration, this rake task will create or update Decidim database.

## Usage

Before using module, you must load the gem in your Decidim application

```ruby
# Gemfile
# [...]
gem "decidim-decidimapp_k8s"
# [...]

```

(If you run the command directly from the module, please create a development_app `bundle exec rake development_app`)

Then you can run the command directly in your shell

```bash
bundle exec rake decidim_app:k8s:external_install_or_reload path=./spec/fixtures/with_extra_admins.yml verbose=y
```

* `path` : path to configuration file
* `log_path` : path to log file. (default: `./log/decidim_app_k8s.log`)
* `verbose` : verbose mode. (default: `false`) - Allows to see more information about what is done in `$stdout`

## Example

You can use the fixture available in specs `./spec/fixtures/with_extra_admins.yml` to create :
* A new system admin
* 2 organizations
* 1 default admin for both organizations
* 2 extra admins for both organizations

```bash
bundle exec rake decidim_app:k8s:external_install_or_reload path=./spec/fixtures/with_extra_admins.yml verbose=y
```

It will logs by default in file `./log/decidim_app_k8s.log`, with the given param `verbose` it also logs in `$stdout` :

**Command is built to be run multiple times and being idempotent**
_For now, each time your rerun the command it will update the database with the given configuration._

Screenshot of `$stdout` :

![Screenshot of stdout](./docs/images/stdout.png)
