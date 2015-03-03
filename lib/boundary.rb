#$: << File.expand_path(File.dirname(__FILE__) + “/../lib”)
require "./use_cases/create_product"

# Implements the so-called 'scar tissue' between the outside imperative shell (i.e. the outside world) and the inner functional core

class Boundary
  attr_reader :repository

  # Initializes the boundary by passing in the arguments coming from the outside imperative shell
  #
  # @param *args
  def initialize(*args)
  	@repository ||= Repository.new
  	create_product(*args)
  end

  # Binds the boundary to the targeted use case ('create priduct') by passing arguments in
  # New instanceof the 'create product' use case instantiated by using dependency injection and passing the boundary in
  #
  # @param *args
  def create_product(*args)
  	CreateProduct.new(self).run(*args)
  end

  # Reports success to the outer imperative shell by returning a String containing the information that describes the success
  #
  # @param [String] msg
  def success(msg)
  	puts msg
  end

  # Reports failure to the outer imperative shell by returning a String containing the information that describes the failure
  #
  # @param [String] err_msg
  def failure(err_msg)
  	puts err_msg
  end
end