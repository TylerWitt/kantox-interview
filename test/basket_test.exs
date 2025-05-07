defmodule BasketTest do
  use ExUnit.Case
  doctest Basket

  alias Basket.Products.InvalidProduct

  test "unknown products raise" do
    product = "asijfiwhfiwe"
    assert_raise InvalidProduct, "product code does not exist, got: \"#{product}\"", fn ->
      Basket.price([product])
    end
  end
end
