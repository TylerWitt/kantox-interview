defmodule Basket.Discounts do
  @moduledoc """
  The context module for discounts
  """

  alias Basket.Discounts.Discount

  @doc "Finds discounts"
  # TODO: Limit discounts based on given products.
  # Right now, all are being fetched. The discounts can be given a hard-coded list of product keys if
  # optimization is needed, at the cost of more coupling.
  @spec all() :: list(Discount.t())
  def all() do
    active_store().all()
  end

  defp active_store do
    Application.fetch_env!(:basket, :discount_store)
  end
end
