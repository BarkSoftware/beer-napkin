use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :beer_napkin, BeerNapkin.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :beer_napkin, BeerNapkin.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "beer_napkin_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :beer_napkin,
  http_module: HTTPMock,
  github_api_url: "https://api.github.com"
