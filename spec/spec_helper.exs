#require phoenix_helper.exs
Code.require_file("#{__DIR__}/phoenix_helper.exs")

ESpec.start

ESpec.configure fn(config) ->
  config.before fn ->
    #restart transactions
    Ecto.Adapters.SQL.restart_test_transaction(BeerNapkin.Repo, [])
  end

  #config.finally fn(_shared) ->

  #end
end
