require 'spec_helper'

describe Faq do

  before do
    @faq = FactoryGirl.create(:faq)

    def generate_faqs(n = 10)
      n.times do |i|
        FactoryGirl.create(:faq)
      end
    end
  end

  ##
  # Medthod index
  describe "index" do
    it "should return array of faqs" do
      10.times do
        FactoryGirl.create(:faq)
      end

      @faqs = Faq.all
      @faqs.count.should eq(11)
    end
  end

  ##
  # Medthod create
  describe "create" do
    before do
      @faq_params = {
        question: "What is love?",
        answer: "Love is nothing"
      }
    end

    it "should create new faq" do
      expect{ @result = Faq.create(@faq_params) } .to change{ Faq.all.length }.by(1)
      @result.question.should eq("What is love?")
    end

    it "should not create new faq" do
      @faq_params[:answer] = nil
      expect{ @result = Faq.create(@faq_params) } .to change{ Faq.all.length }.by(0)
    end

    it "should create 10 new faq" do
      expect{ generate_faqs(10) }.to change{ Faq.all.length }.by(10)
    end
  end


  ##
  # Medthod update
  describe "update" do
    before do
      @faq = FactoryGirl.create(:faq)
    end

    it "should update faq" do
      @faq_params = {
        question: "What is love?",
        answer: "Love is nothing"
      }
      @faq.update(@faq_params).should eq(true)
      @faq.question.should eq("What is love?")
      @faq.answer.should eq("Love is nothing")
    end

    it "can not update faq" do
      @faq.update(answer: nil).should_not eq(true)
    end
  end

  ##
  # Method destroy
  describe "destroy" do
    before do
      @faq = FactoryGirl.create(:faq)
    end

    it "should destroy faq" do
      expect{ @result = Faq.where(id: @faq.id).first.destroy }.to change{ Faq.count }.by(-1)
    end

    it "should not destroy faq because of not found error" do
      @result = Faq.where(id: 123).first
      @result.respond_to?(:destroy).should eq(false)
    end
  end

end