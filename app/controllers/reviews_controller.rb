class ReviewsController < ApplicationController
  def index
    @review = Review.where(promotion_id: params[:id])
  end

  def create
    if  params[:review]["rating"].nil?
      params[:review]["rating"] = 2.5
    end
    @review = Review.new(
      content: params[:review]["content"], 
      user_id: params[:review]["user_id"], 
      promotion_id: params[:id],
      rating: params[:review]["rating"]
      )

    respond_to do |format|
      if @review.save
        @review = Review.where(promotion_id: params[:id])
        format.json { render json: @review }
      else
        format.html { render action: 'new' }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params[:review]
    end
end
