CREATE TABLE [product_category_translation] (
  [product_category_name] nvarchar(255) PRIMARY KEY,
  [product_category_name_english] nvarchar(255)
)
GO

CREATE TABLE [products] (
  [product_id] nvarchar(255) PRIMARY KEY,
  [product_category_name] nvarchar(255),
  [product_name_length] int,
  [product_description_length] int,
  [product_photos_qty] int,
  [product_weight_g] int,
  [product_length_cm] int,
  [product_height_cm] int,
  [product_width_cm] int
)
GO

CREATE TABLE [sellers] (
  [seller_id] nvarchar(255) PRIMARY KEY,
  [seller_zip_code_prefix] int,
  [seller_city] nvarchar(255),
  [seller_state] nvarchar(255)
)
GO

CREATE TABLE [customers] (
  [customer_id] nvarchar(255) PRIMARY KEY,
  [customer_unique_id] nvarchar(255),
  [customer_zip_code_prefix] int,
  [customer_city] nvarchar(255),
  [customer_state] nvarchar(255)
)
GO

CREATE TABLE [geolocation] (
  [geolocation_zip_code_prefix] int,
  [geolocation_lat] float,
  [geolocation_lng] float,
  [geolocation_city] nvarchar(255),
  [geolocation_state] nvarchar(255)
)
GO

CREATE TABLE [orders] (
  [order_id] nvarchar(255) PRIMARY KEY,
  [customer_id] nvarchar(255),
  [order_status] nvarchar(255),
  [order_purchase_timestamp] datetime,
  [order_approved_at] datetime,
  [order_delivered_carrier_date] datetime,
  [order_delivered_customer_date] datetime,
  [order_estimated_delivery_date] datetime
)
GO

CREATE TABLE [order_items] (
  [order_id] nvarchar(255),
  [order_item_id] int,
  [product_id] nvarchar(255),
  [seller_id] nvarchar(255),
  [shipping_limit_date] datetime,
  [price] float,
  [freight_value] float,
  PRIMARY KEY ([order_id], [order_item_id])
)
GO

CREATE TABLE [payments] (
  [order_id] nvarchar(255),
  [payment_sequential] int,
  [payment_type] nvarchar(255),
  [payment_installments] int,
  [payment_value] float,
  PRIMARY KEY ([order_id], [payment_sequential])
)
GO

CREATE TABLE [reviews] (
  [review_id] nvarchar(255) PRIMARY KEY,
  [order_id] nvarchar(255),
  [review_score] int,
  [review_comment_title] nvarchar(255),
  [review_comment_message] text,
  [review_creation_date] datetime,
  [review_answer_timestamp] datetime
)
GO

ALTER TABLE [products] ADD FOREIGN KEY ([product_category_name]) REFERENCES [product_category_translation] ([product_category_name])
GO

ALTER TABLE [orders] ADD FOREIGN KEY ([customer_id]) REFERENCES [customers] ([customer_id])
GO

ALTER TABLE [order_items] ADD FOREIGN KEY ([order_id]) REFERENCES [orders] ([order_id])
GO

ALTER TABLE [order_items] ADD FOREIGN KEY ([product_id]) REFERENCES [products] ([product_id])
GO

ALTER TABLE [order_items] ADD FOREIGN KEY ([seller_id]) REFERENCES [sellers] ([seller_id])
GO

ALTER TABLE [payments] ADD FOREIGN KEY ([order_id]) REFERENCES [orders] ([order_id])
GO

ALTER TABLE [reviews] ADD FOREIGN KEY ([order_id]) REFERENCES [orders] ([order_id])
GO

ALTER TABLE [customers] ADD FOREIGN KEY ([customer_zip_code_prefix]) REFERENCES [geolocation] ([geolocation_zip_code_prefix])
GO

ALTER TABLE [sellers] ADD FOREIGN KEY ([seller_zip_code_prefix]) REFERENCES [geolocation] ([geolocation_zip_code_prefix])
GO
