require 'spec_helper'

describe Category do
  ### TEST ASSOCIATIONS
  context "Associations" do
    it { should belong_to(:user) }
    it { should have_and_belong_to_many(:promotions) }
  end
  context "Validations" do
    it { should validate_presence_of(:name) }
    it {should ensure_length_of(:name).is_at_most(255)}
  end

end
