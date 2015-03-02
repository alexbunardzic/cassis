require "rspec/given"

describe "Create product" do
  Given(:name){ "Shiny product" }
  When "validate name not blank"
  Then {result.should be_success}
end