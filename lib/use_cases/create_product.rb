require "./repository"
require "./validator"

# Use case governing the scenario describing the creation of a product

class CreateProduct
  attr_reader :boundary, :repository

  # Initializes the use case
  #
  # @param one [Boundary] boundary
  def initialize(boundary)
  	@boundary = boundary
  	@repository = boundary.repository
  end

  # Executes the use case that was activated by the trigger event
  #
  # @param #args
  def run(*args)
  	product = repository.new_product(*args)
  	result = repository.validate_product_nil(product, "Product is nil").lift_to_a +
  	result = repository.validate_name_not_blank(*args, "Name is blank").lift_to_a

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