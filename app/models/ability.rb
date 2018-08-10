class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :destroy, User
      can :manage, :all
    elsif user.leader?
      can :create, Group
    elsif user.member?
      can :destroy, Report
      can :create, Report
    end
  end
end
