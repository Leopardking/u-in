require 'spec_helper'

describe WorkingSchedule do

  ##
  # TEST FIELDS
  context "Fields" do
    it { should have_db_column :monday }
    it { should have_db_column :tuesday }
    it { should have_db_column :wednesday }
    it { should have_db_column :thursday }
    it { should have_db_column :friday }
    it { should have_db_column :saturday }
    it { should have_db_column :sunday }
    it { should have_db_column :start_date }
    it { should have_db_column :end_date }
    it { should have_db_column :start_time }
    it { should have_db_column :end_time }
    it { should have_db_column :schedule_name }
    it { should have_db_column :segment }
    it { should have_db_column :segment_duration }
    it { should have_db_column :active }
  end

  ##
  # TEST VALIDATIONS
  context "Validations" do
    it { should validate_presence_of(:schedule_name) }
  end

  ##
  # TEST RELATIONSHIPS
  context "Relationship" do
    it { should belong_to :user }
    it { should have_many :break_times }
  end
end
