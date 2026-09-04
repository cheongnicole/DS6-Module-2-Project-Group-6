-- models/core/fct_order_items.sql

{{ config(materialized='table') }}

SELECT
  order_id,
  order_item_id,
  product_id,
  price

FROM {{ source('staging', 'stg_order_items') }}