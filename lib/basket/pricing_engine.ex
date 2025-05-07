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

    # Looping through products instead of discounts allows us to accumulate the discounts for a product,
    # which lets us "smartly" apply them if needed, instead of the inverse where we loop through discounts
    # and just apply them in-order.
    #
    # Admittedly, I'm sure that this code block would change with real data for whatever reason--without more
    # use-case info it's a hard to assume which direction this will go, but it's good enough in the context of
    # the original problem statement.
    for basket_item <- basket, into: %{} do
      case Enum.filter(discounts, fn discount ->
             discount.application_rule.(basket_item, basket)
           end) do
        [] ->
          basket_item

        discounts ->
          process_discounts_for_product(discounts, basket_item)
      end
    end
  end

  defp process_discounts_for_product([], basket_item), do: basket_item

  defp process_discounts_for_product([discount | rest], basket_item) do
    basket_item = process_discount(discount, basket_item)
    process_discounts_for_product(rest, basket_item)
  end

  defp process_discount(discount, basket_item) do
    discount.pricing_rule.(basket_item)
  end
end
