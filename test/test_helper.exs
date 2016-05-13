ExUnit.start

Mix.Task.run "ecto.create", ~w(-r BeerNapkin.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r BeerNapkin.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(BeerNapkin.Repo)

