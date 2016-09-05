class ReviewsController < ApplicationController
  before_action :set_promotion, only: [:create, :index]

  def index
    @reviews =  @promotion.reviews
  end

  def create
    @review = @promotion.reviews.new(review_params)

    respond_to do |format|
      if @review.save
        format.json { render json: @review }
      else
        format.html { render action: 'new' }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_promotion
      @promotion = Promotion.find(params[:id])  
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:content, :user_id, :rating, :promotion_id).merge(:user_id => current_user.id)
    end
end
