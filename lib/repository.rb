require "./entities/product"
require "rumonade"

# Entity gateway acting as an intermediary between instantiated business entities and the underlying persistence commodity layer.

class Repository
  # Instantiates a new product by passing arguments in
  #
  # @param *args
  # @return [Product] instance of the business entity Product
  def new_product(*args)
  	Product.new(*args)
  end

  # Persists the instance of a Product
  #
  # @param product
  def save_product(product)
  	product.save
  end

  # Checks in the instance of a Product is nil
  #
  # @param one [Product] product
  # @param two [String] error_message
  # @return [either] -- instance of a Product if not nil, otherwise error_message
  def validate_product_nil(product, error_message)
  	if product.nil? then Left(error_message) else Right(product) end
  end

  # Checks in the name of instantiated Product is blank or not
  #
  # @param one [String] product name
  # @param two [String] err
  # @return [either] -- String if not blank, otherwise err
  def validate_name_not_blank(name, err)
  	if name.length < 1 then Left(err) else Right(name) end
  end
end