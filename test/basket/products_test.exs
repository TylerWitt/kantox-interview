defmodule Basket.ProductsTest do
  use ExUnit.Case, async: false

  alias Basket.Products

  defmodule TestStore do
    @behaviour Products.Store

    @impl true
    def find_product("-1"), do: nil

    def find_product(product_code) do
      %Products.Product{
        product_code: product_code,
        name: product_code,
        price: 1.00
      }
    end
  end

  setup_all do
    current_store = Application.get_env(:basket, :product_store)

    on_exit(fn ->
      Application.put_env(:basket, :product_store, current_store)
    end)

    Application.put_env(:basket, :product_store, TestStore)
  end

  test "raises when items are not found" do
    assert_raise Products.InvalidProduct, "product code does not exist, got: \"-1\"", fn ->
      Products.find_product("-1")
    end
  end

  test "returns the product when found" do
    code = "AA1"

    result = Products.find_product(code)

    assert result.product_code == code
  end
end
