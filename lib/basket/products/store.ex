defmodule Basket.Products.Store do
  @moduledoc """
  The behaviour of product stores.

  This is useful for tests. For example, to test category-based discounts without changing the
  global product list, we can implement a TestStore and inject it.
  """

  alias Basket.Products.Product

  @doc "Finds a product or returns nil if it does not exist"
  @callback find_product(product_code :: Product.product_code()) :: Product.t() | nil
end
