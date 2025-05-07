defmodule Basket do
  @moduledoc """
  An order independent price builder.
  """

  alias Basket.PricingEngine

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

      iex> Basket.price([])
      "£0.00"

  """
  @spec price(products :: list(String.t())) :: String.t()
  def price(products) do
    products
    |> PricingEngine.process()
    |> Money.to_string()
  end
end
