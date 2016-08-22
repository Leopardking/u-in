class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin? # Permission for admin
      can :manage, User
      can :manage, Faq
      can [:admin,:manage], Category
      can [:book], Booking
    else
      if user.merchant? # Permission for merchant
        can :index, Faq
        can :manage, Promotion do |p|
          p.user_id == user.id
        end
        can :add_card, User
        # can :change, Promotion do |p|
        #   p.user_id == user.id
        # end
        cannot :book, Promotion
        can [:read, :write], Category
        can [:business_address], User
      else # Permission for client
        cannot :manage, User
        can :add_card, User
        can :index, Faq
        cannot [:create, :update, :destroy], Faq
        # cannot :manage, Promotion
        can [:contact, :send_contact], User
        can [:book], Booking
        can [:book, :share], Promotion
      end

    end
  end
end
