defmodule BeerNapkin.PostsRequestsSpec do
  use ESpec.Phoenix, request: BeerNapkin.Endpoint

  #describe "index" do
    #before do
      #ex1 = %BeerNapkin.Example{title: "Example 1"} |> BeerNapkin.Repo.insert
      #ex2 = %BeerNapkin.Example{title: "Example 2"} |> BeerNapkin.Repo.insert
      #{:ok, ex1: ex1, ex2: ex2}
    #end

    #subject! do: get(conn(), examples_path(conn(), :index))

    #it do: should be_successful
    #it do: should be_success

    #context "check body" do
      #let :html, do: subject.resp_body

      #it do: html |> should(have_content shared.ex1.title)
      #it do: html |> should(have_text shared.ex2.title)
    #end
  #end
end
