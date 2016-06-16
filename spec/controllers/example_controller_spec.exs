defmodule BeerNapkin.ExampleControllerSpec do
  use ESpec.Phoenix, controller: BeerNapkin.ExampleController

  #describe "index" do
    #let :examples do
      #[
        #%BeerNapkin.Example{title: "Example 1"},
        #%BeerNapkin.Example{title: "Example 2"},
      #]
    #end

    #before do
      #allow(BeerNapkin.Repo).to accept(:all, fn -> examples end)
    #end

    #subject do: action :index

    #it do: should be_successful
    #it do: should have_in_assigns(examples: examples)
  #end
end
