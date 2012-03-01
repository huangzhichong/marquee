class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

    user ||= User.new # guest user

    can :read, [TestRound, TestPlan, TestSuite, AutomationScript, AutomationCase, TestCase, AutomationScriptResult, AutomationCaseResult, Project]

    user.projects_roles.each do |project_role|
      role = project_role.role
      if role.name == 'admin'
        can :manage, :all
      else
        role.ability_definitions.each do |ad|
          can ad.ability.to_sym, ad.resource.constantize
          puts "#{ad.ability}, #{ad.resource}"
        end
      end
    end

    user.ability_definitions.each do |uad|
      can uad.ability.to_sym, uad.resource.constantize
      puts "#{uad.ability}, #{uad.resource}"
    end

  end
end
