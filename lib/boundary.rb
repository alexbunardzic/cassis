#$: << File.expand_path(File.dirname(__FILE__) + “/../lib”)
require "./use_cases/create_product"

class Boundary
  attr_reader :repository

  def initialize(*args)
    customer = Customer.new(nil)
    loan = Struct.new(:c)
    if customer
      puts "YAY!" + customer.loan.to_s
    end
  	@repository ||= Repository.new
  	create_product(*args)
  end

  def create_product(*args)
  	CreateProduct.new(self).run(*args)
  end

  def success(msg)
  	puts msg
  end

  def failure(err_msg)
  	puts err_msg
  end

  class Customer
    def initialize(loan)
      Loan.new
    end
  end

  class Loan
  end
end