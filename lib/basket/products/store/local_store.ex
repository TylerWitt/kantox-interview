defmodule Basket.Products.Store.LocalStore do
  @moduledoc """
  The local storage of products.

  In a "real" environment, this would likely be a database implementation.
  """

  alias Basket.Products.Product

  @behaviour Basket.Products.Store

  @products %{
    "GR1" => %Product{
      product_code: "GR1",
      category: "Green tea",
      price: Money.new(311),
      name: "Green tea"
    },
    "SR1" => %Product{
      product_code: "SR1",
      category: "Strawberry",
      price: Money.new(500),
      name: "Strawberry"
    },
    "CF1" => %Product{
      product_code: "CF1",
      category: "Coffee",
      price: Money.new(1123),
      name: "Coffee"
    }
  }

  @impl Basket.Products.Store
  def find_product(product_code) do
    @products[product_code]
  end
end
