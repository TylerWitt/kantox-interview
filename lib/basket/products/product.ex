defmodule Basket.Products.Product do
  @moduledoc """
  The representation of a product.
  """

  @type t :: %__MODULE__{
          product_code: product_code(),
          name: String.t(),
          price: float(),
          category: String.t() | nil
        }

  @type product_code :: String.t()

  defstruct [:product_code, :name, :price, category: nil]
end
