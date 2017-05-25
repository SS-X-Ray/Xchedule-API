# frozen_string_literal: true

# Policy to determine if account can view a project
class ActivityPolicy
  # Scope of activity policies
  class Scope
    def initialize(current_account, target_account)
      @scope = all_activities(target_account)
      @current_account = current_account
      @target_account = target_account
    end

    def viewable
      if @current_account == @target_account
        @scope
      else
        @scope.select { |proj| includes_contributor?(proj, @current_account) }
      end
    end

    private

    def all_activities(account)
      account.organized_activities + account.activities
    end

    def includes_participants?(activity, account)
      activity.participants.include? account
    end
  end
end
