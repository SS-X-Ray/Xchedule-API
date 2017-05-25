# frozen_string_literal: true

# Policy to determine if an account can view a particular project
class ActivityPolicy
  def initialize(account, activity)
    @account = account
    @activity = activity
  end

  def can_view_activity?
    account_is_organizer? || account_is_participant?
  end

  # duplication is ok!
  def can_edit_activity?
    account_is_organizer? || account_is_participant?
  end

  def can_delete_activity?
    account_is_owner?
  end

  def can_leave_activity?
    account_is_contributor?
  end

  def can_add_participant?
    account_is_owner?
  end

  def can_remove_participant?
    account_is_owner?
  end

  def summary
    {
      view_activity: can_view_activity?,
      edit_activity: can_edit_activity?,
      delete_activity: can_delete_activity?,
      leave_activity: can_leave_activity?,
      can_add_participant: can_add_participant?,
      can_remove_participant: can_remove_participant?
    }
  end

  private

  def account_is_organizer?
    @activity.organizer == @account
  end

  def account_is_participant?
    @activity.participants.include?(@account)
  end
end
