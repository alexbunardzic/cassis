# Implements generic applicative validation logic by evaluating the value and returning disjoint union type

class Validator
  # Implements the 'either' type from the 'rumonade' gem
  #
  # @param one value
  # @param two block
  # @return [either]
  def self.valid? value, &block
  	value.right? ?
  	  value.right.bind(&block) :
  	  false
  end
end