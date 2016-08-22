require 'spec_helper'

describe Promotion do
  ### TEST ASSOCIATIONS
  context "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:working_schedule) }
    it { should have_many(:images).dependent(:destroy) }
    it { should have_many(:bookings).dependent(:destroy) }
    it { should have_and_belong_to_many(:categories) }
    it { should accept_nested_attributes_for(:categories) }
  end

  ### TEST VALIDATIONS
  context "Validations" do
    it { should validate_presence_of(:categories) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it {should ensure_length_of(:description).is_at_most(255)}
    it {should ensure_length_of(:name).is_at_most(255)}
    it { should validate_presence_of(:street_address_1) }
    it { should validate_presence_of(:street_address_2) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:zipcode) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:discount_percent) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
    it { should validate_presence_of(:booking_available) }
    it { should validate_presence_of(:cancellation_fee) }

    it { should validate_numericality_of(:price) }
    it { should validate_numericality_of(:discount_percent) }
    it { should validate_numericality_of(:discount_price) }
    it { should validate_numericality_of(:booking_available).only_integer }

  end
end
