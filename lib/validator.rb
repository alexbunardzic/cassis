class Validator
  def self.valid? value, &block
  	value.right? ?
  	  value.right.bind(&block) :
  	  false
  end
end