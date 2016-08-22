module PromotionHelper
  def form_errors!(object)
    unless object.errors.empty?
      html = content_tag(:div, class: "row") do
        content_tag(:div, class: "col-md-12") do
          content_tag(:div, class: "alert alert-dismissable alert-danger") do
            html = '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>'
            object.errors.full_messages.each do |m|
              html += "#{m}.<br />"
            end
            html.html_safe
          end
        end
      end
    end
  end

  def form_errors?(object)
    object.errors.empty? ? false : true
  end

  def form_notice_alert!
    if flash[:notice]
      html = content_tag(:div, class: "row") do
        content_tag(:div, class: "col-md-12") do
          content_tag(:div, class: "alert alert-dismissable alert-info") do
            html = '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>'
            html += "#{flash[:notice]}"
            html.html_safe
          end
        end
      end
    else
      if flash[:error]
        html_e = content_tag(:div, class: "row") do
          content_tag(:div, class: "col-md-12") do
            content_tag(:div, class: "alert alert-dismissable alert-danger") do
              html_e = '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>'
              html_e += "#{flash[:error]}"
              html_e.html_safe
            end
          end
        end
      else
        if flash[:alert]
          html_a = content_tag(:div, class: "row") do
            content_tag(:div, class: "col-md-12") do
              content_tag(:div, class: "alert alert-dismissable alert-warning") do
                html_a = '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>'
                html_a += "#{flash[:alert]}"
                html_a.html_safe
              end
            end
          end
        end
      end
    end
  end
  def options_for_list(working_schedule_lists)
    if working_schedule_lists.count > 0
      working_schedule_lists.map do |ws|
        [ ws.schedule_name, ws.id ]
      end
    else
      working_schedule_lists=[[I18n.t("promotions.form_promotion.no_working_schedule"), nil], [I18n.t("promotions.form_promotion.create_new_schedule"), 0]]
    end
  end
  def option_for_per(input)
    if input.count>0
      Promotion::PER_SCHEDULE
    else
      output=[[I18n.t("promotions.form_promotion.no_per_schedule"), nil]]
    end
  end

  def short_promotion_description(promotion)
    desc = promotion.description[0..199]
    desc = "#{desc}..." if promotion.description.length > 199
    desc
  end

  def ranking_data promotion
    @rank_data ||= promotion.get_current_rank
  end

  def get_image_follow_id ids
    Image.where(id: ids)
  end

  def get_image_follow_default images
    images.where(image_default: true).order("updated_at").last
  end

  def show_image_default_step5_step6 promotion, image_ids
    if promotion.main_image.present?
      image_url = promotion.main_image.image.url(:medium)
    else
      if image_ids.present? && image_ids.first.present?
        images = Image.where(id: image_ids)
        images.each do |img|
          if img.image_default
            image_url = img.image.url(:medium)
          else
            image_url ||= "question.svg"
          end
        end
      else
        image_url = "question.svg"
      end
      image_url
    end
  end

end
