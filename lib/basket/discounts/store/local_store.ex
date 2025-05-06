defmodule Basket.Discounts.Store.LocalStore do
  @moduledoc """
  The local storage of discounts.

  These are tightly coupled to products (obviously).
  """

  alias Basket.Discounts.Discount
  alias Basket.Products

  @behaviour Basket.Discounts.Store

  @impl Basket.Discounts.Store
  def all do
    [
      %Discount{
        name: "Buy-One-Get-One Green Tea!",
        application_rule: fn product, basket ->
          product.product_code == "GR1" && basket[product] >= 2
        end,
        pricing_rule: fn product, count -> Discount.buy_x_get_y_free(1, 1, product, count) end
      },
      %Discount{
        name: "Bulk Strawberries!",
        application_rule: fn product, basket ->
          product.product_code == "SR1" && basket[product] >= 3
        end,
        pricing_rule: fn product, count ->
          Discount.static_price(Money.new(450), product, count)
        end
      },
      %Discount{
        name: "Bulk Coffee!",
        application_rule: fn product, basket ->
          product.category == "Coffee" && Products.basket_category_sum(basket, "Coffee") >= 3
        end,
        pricing_rule: fn product, count -> Discount.buy_x_get_y_free(2, 1, product, count) end
      }
    ]
  end
end
