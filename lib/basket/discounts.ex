defmodule Basket.Discounts do
  @moduledoc """
  The context module for discounts
  """

  alias Basket.Discounts.Discount

  @doc "Finds discounts"
  @spec all() :: list(Discount.t())
  def all() do
    active_store().all()
  end

  defp active_store do
    Application.fetch_env!(:basket, :discount_store)
  end
end
