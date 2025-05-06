defmodule Basket.Discounts.Discount do
  @moduledoc """
  The representation of a discount.

  Discounts have application rules, and pricing rules.

  Application rules are meant to be invoked to determine if the discount is
  applicable over the entire course of the basket.

  Pricing rules are meant to be invoked to actually adjust the basket pricing/effective
  product count.

  As an example,

  ```
  %Discount{
        name: "Buy-One-Get-One Green Tea!",
        application_rule: fn product, basket ->
          product.product_code == "GR1" && basket[product] >= 2
        end,
        pricing_rule: fn product, count -> Discount.buy_x_get_y_free(1, 1, product, count) end
      }
  ```

  The above discount will take effect when there are more than 1 item with the product code `GR1`, and
  will adjust the count of the product with buy-one-get-one rules.

  This module has some helpers for pricing, but any anonymous function with the correct signature is usable.
  """

  alias Basket.Products.Product

  @type t() :: %__MODULE__{
          name: String.t(),
          application_rule: (Product.t(), map() -> boolean()),
          pricing_rule: (Product.t(), pos_integer() -> {Product.t(), pos_integer()})
        }

  defstruct [:name, :activation_rule, :application_rule, :pricing_rule]

  @doc """
  Logic to apply BxGy discounts.

  ### Examples

    iex> buy_x_get_y_free(2, 1, %Basket.Products.Product{}, 5)
    {%Basket.Products.Product{}, 4}

    iex> buy_x_get_y_free(1, 1, %Basket.Products.Product{}, 5)
    {%Basket.Products.Product{}, 3}

    iex> buy_x_get_y_free(1, 2, %Basket.Products.Product{}, 5)
    {%Basket.Products.Product{}, 2}

    iex> buy_x_get_y_free(2, 1, %Basket.Products.Product{}, 9)
    {%Basket.Products.Product{}, 6}

    iex> buy_x_get_y_free(1, 1, %Basket.Products.Product{}, 9)
    {%Basket.Products.Product{}, 5}

    iex> buy_x_get_y_free(1, 2, %Basket.Products.Product{}, 9)
    {%Basket.Products.Product{}, 3}
  """
  def buy_x_get_y_free(x, y, %Product{} = product, count) when x > 0 and y > 0 do
    group_size = x + y
    full_groups = div(count, group_size)
    remaining = rem(count, group_size)

    paid_in_full_groups = full_groups * x
    paid_in_remaining = min(remaining, x)

    {product, paid_in_full_groups + paid_in_remaining}
  end

  @doc """
  Logic to apply static price changes.

  ### Examples

    iex> static_price(Decimal.new("4.50"), %Basket.Products.Product{}, 3)
    {%Basket.Products.Product{price: Decimal.new("4.50")}, 3}
  """
  def static_price(price, %Product{} = product, count) do
    {%Product{product | price: price}, count}
  end

  @doc """
  Logic to change prices by a percentage.

  ### Examples

    iex> reduce_price(Decimal.div(1, 2), %Basket.Products.Product{price: Decimal.new("300.00")}, 3)
    {%Basket.Products.Product{price: Decimal.new("150.000")}, 3}
  """
  def reduce_price(percentage, %Product{} = product, count) do
    {%Product{product | price: Decimal.mult(product.price, percentage)}, count}
  end
end
