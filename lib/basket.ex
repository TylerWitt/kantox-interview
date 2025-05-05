defmodule Basket do
  @moduledoc """
  An order independent price builder.
  """

  @doc """
  Returns the price of the list of products, including any discounts.

  ## Examples

      iex> Basket.price(["GR1","SR1","GR1","GR1","CF1"])
      "£22.45"

      iex> Basket.price(["GR1","GR1"])
      "£3.11"

      iex> Basket.price(["SR1","SR1","GR1","SR1"])
      "£16.61"

      iex> Basket.price(["GR1","CF1","SR1","CF1","CF1"])
      "£30.57"

  """
  def price(_products) do
    raise "implement"
  end
end
