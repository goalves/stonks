![Continuous Integration](https://github.com/goalves/stonks/workflows/Continuous%20Integration/badge.svg?branch=master)

# Stonks

This repository contains application of the Stonks project. This application simulates a Bank API.

## Dependencies

The application depends on multiple parts to work properly. Even though it is possible to boot up in different ways, the recommended settings are as follows:

- Elixir 1.10-otp22;
- Erlang 22.1;
- Docker for having local Postgres 11;

## Setting Up Local Environment

First of all, you need to fetch all dependencies for the application using `mix deps.get`.

We use Docker to set up the container containing the Postgres database, to start it you need to run:

```sh
docker-compose up -d
mix ecto.setup
```

To start the application, you need to run `mix phx.server`.

It is important to notice that running locally uses development configuration, therefore emails are not sent.

## Running Tests and Static Code Analysis

All of them should run on CI, but you can run them locally using the following commands:

- [Coveralls](https://github.com/parroty/excoveralls): `mix coveralls` for test coverage;
- [Dialyxir](https://github.com/jeremyjh/dialyxir): `mix dialyzer` for static code analysis and spec validation;
- [Sobelow](https://github.com/nccgroup/sobelow): `mix sobelow --config` for static code analysis focused on security and a few performance aspects;
- [Credo](https://github.com/rrrene/credo): `mix credo` for general static code analysis;
- Elixir default Formatter: `mix format --check-formatted` for ensuring codebase is formatted.

## Generating API Documentation

To generate the API documentation, you can use the following command:

```sh
API_DOCS=1 mix test
```

This will generate the Markdown file for the API Blueprint format, it is written in the `docs/documentation.md` file.

If you want to generate a readable HTML, you can render this file to a template using [Aglio][https://github.com/danielgtaylor/aglio].

You can install it it using `yarn global add aglio` or `npm install -g aglio`, depending on your package manager of choice. And then run:

```sh
aglio -i docs/documentation.md -o docs/documentation.html
```

And you can check the latest available documentation acessing the `docs/documentation.html` file.

Alternatively, you can use a docker container and mount the correct volumes, but that is better disected in Aglio documentation itself.

## Building the Application

To build the application the best option is to use `Releases`, you can build a release using `mix release`.

It is possible to build a container the application using the provided Dockerfile using:

`docker build .`

However, to run it you would need to manually start the built container and bind it to the correct port.

## Deployments

Application is currently hosted on Heroku at https://stonks-bank.herokuapp.com/.
Any push to the `production` branch will trigger a new deploy on heroku.
