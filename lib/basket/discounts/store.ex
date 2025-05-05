defmodule Basket.Discounts.Store do
  @moduledoc """
  The behaviour of discount stores.

  This is useful for tests.
  """

  alias Basket.Discounts.Discount

  @doc "Returns all known discounts"
  @callback all() :: list(Discount.t())
end
