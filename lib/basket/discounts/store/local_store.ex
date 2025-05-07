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
        application_rule: fn {product, count}, _basket ->
          product.product_code == "GR1" && count >= 2
        end,
        pricing_rule: fn basket_item -> Discount.buy_x_get_y_free(1, 1, basket_item) end
      },
      %Discount{
        name: "Bulk Strawberries!",
        application_rule: fn {product, count}, _basket ->
          product.product_code == "SR1" && count >= 3
        end,
        pricing_rule: fn basket_item ->
          Discount.static_price(Decimal.new("4.50"), basket_item)
        end
      },
      %Discount{
        name: "Bulk Coffee!",
        application_rule: fn {product, _count}, basket ->
          product.category == "Coffee" && Products.basket_category_sum(basket, "Coffee") >= 3
        end,
        pricing_rule: fn basket_item ->
          Discount.reduce_price(Decimal.div(2, 3), basket_item)
        end
      }
    ]
  end
end
