defmodule Basket.PricingEngine do
  @moduledoc """
  The meat of the business logic for pricing, products, and discounts.
  """

  alias Basket.Discounts
  alias Basket.Products

  @doc """
  Processes a basket of products and returns the price.
  """
  @spec process(products :: list(String.t())) :: Money.t()
  def process(products) do
    products
    |> Products.generate_basket()
    |> apply_discounts()
    |> sum_prices()
    |> Money.parse!()
  end

  defp sum_prices(basket) do
    Enum.reduce(basket, Decimal.new("0"), fn {product, count}, acc ->
      Decimal.add(acc, Decimal.mult(product.price, count))
    end)
  end

  defp apply_discounts(basket) do
    discounts = Discounts.all()

    for {product, count} <- basket, into: %{} do
      case Enum.filter(discounts, fn discount -> discount.application_rule.(product, basket) end) do
        [] ->
          {product, count}

        discounts ->
          process_discounts_for_product(discounts, product, count)
      end
    end
  end

  defp process_discounts_for_product([], product, count), do: {product, count}

  defp process_discounts_for_product([discount | rest], product, count) do
    {product, count} = process_discount(discount, product, count)
    process_discounts_for_product(rest, product, count)
  end

  defp process_discount(discount, product, count) do
    discount.pricing_rule.(product, count)
  end
end
