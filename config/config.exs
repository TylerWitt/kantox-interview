import Config

config :basket, :discount_store, Basket.Discounts.Store.LocalStore

config :basket, :product_store, Basket.Products.Store.LocalStore
