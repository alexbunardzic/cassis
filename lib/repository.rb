require "./entities/product"
require "rumonade"

class Repository
  def new_product(*args)
  	Product.new(*args)
  end

  def save_product(product)
  	product.save
  end

  def validate_product_nil(product, error_message)
  	if product.nil? then Left(error_message) else Right(product) end
  end

  def validate_name_not_blank(name, err)
  	if name.length < 1 then Left(err) else Right(name) end
  end
end