defmodule Basket.Products do
  @moduledoc """
  The context module for Products
  """

  alias Basket.Products.Product

  defmodule InvalidProduct do
    defexception [:message]

    @impl true
    def exception(value) do
      msg = "product code does not exist, got: #{inspect(value)}"
      %__MODULE__{message: msg}
    end
  end

  @doc "Finds a product or raises if it does not exist"
  @spec find_product(product_code :: Product.product_code()) :: Product.t()
  def find_product(product_code) do
    case active_store().find_product(product_code) do
      nil ->
        raise InvalidProduct, product_code

      product ->
        product
    end
  end

  defp active_store do
    Application.fetch_env!(:basket, :product_store)
  end
end
