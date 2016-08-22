require 'spec_helper'

describe Faq do

  ##
  # TEST VALIDATIONS
  context "Validations" do
    it { should validate_presence_of(:question) }
    it { should validate_presence_of(:answer) }
  end

end
