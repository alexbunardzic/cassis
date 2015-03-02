require "./repository"
require "./validator"

class CreateProduct
  attr_reader :boundary, :repository

  def initialize(boundary)
  	@boundary = boundary
  	@repository = boundary.repository
  end

  def run(*args)
  	product = repository.new_product(*args)
  	result = repository.validate_product_nil(product, "Product is nil").lift_to_a +
  	result = repository.validate_name_not_blank("", "Name is blank").lift_to_a

  	unless Validator.valid?(result){|args| product}
  	  result.left.bind do |e|
  	  	boundary.failure(e.join(', '))
  	  end
  	else
  	  if repository.save_product(product)
  	    boundary.success(product)
  	  else
  	    boundary.failure("Product not saved")
  	  end
  	end
  end
end