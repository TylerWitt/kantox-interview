defmodule Basket.MixProject do
  use Mix.Project

  def project do
    [
      app: :basket,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # I could have used Decimal instead, but there is a good argument here to use money
      # https://www.martinfowler.com/eaaCatalog/money.html
      {:money, "~> 1.14"}
    ]
  end
end
