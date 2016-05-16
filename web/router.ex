defmodule BeerNapkin.Router do
  use BeerNapkin.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug BeerNapkin.UserContext, nil
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BeerNapkin do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/napkins", NapkinController
  end

  scope "/auth", BeerNapkin do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", BeerNapkin do
  #   pipe_through :api
  # end
end
