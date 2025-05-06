defmodule Basket.PricingEngineTest do
  use ExUnit.Case, async: false

  alias Basket.Products.Product
  alias Basket.Products.Store

  alias Basket.PricingEngine

  defmodule TestProductStore do
    @behaviour Store

    @impl true
    def find_product("CF1") do
      %Product{
        product_code: "CF1",
        name: "CF1",
        category: "Coffee",
        price: Decimal.new("100.00")
      }
    end

    def find_product("CF2") do
      %Product{
        product_code: "CF2",
        category: "Coffee",
        price: Decimal.new("200.00")
      }
    end
  end

  setup_all do
    current_store = Application.get_env(:basket, :product_store)

    on_exit(fn ->
      Application.put_env(:basket, :product_store, current_store)
    end)

    Application.put_env(:basket, :product_store, TestProductStore)
  end

  test "category level discounts are accounted for" do
    assert Money.new(30000) == PricingEngine.process(["CF1", "CF2"])
    assert Money.new(33333) == PricingEngine.process(["CF1", "CF2", "CF2"])
  end
end
