# Basket

## Implementation notes

These are notes that only exist for the assignment. In a real code-base I would leave this information in the codebase and not in the README.

To support multiple discounts on a single product, we would need an application order field. If
many kinds of overlap are anticipated, it might be more worth it to have the pricing engine apply the discounts
in each order to determine the most beneficial application on its own.

Discount performance might be increased by filtering the discounts by the products in the cart. Right now,
all are fetched, which is fast--but it won't scale to thousands of products and hundreds of discounts, as an example.

For discounts that apply to more than one product, simple caching could increase processing speeds as well in order to
not need to run the `application_rules` multiple times.

There are less tests than I want, but when I go through to try to figure out what to add, it would consist of making up products and discounts,
which would make more sense to do when the requirements change. The most important tests are doctests in `basket.ex`.

## Contributing

Run `mix deps.get` to install dependencies, and `mix test` to test.

Please format with `mix format`!
