class FindAllAccountActivities
  def self.call(id:)
    account = BaseAccount.where(id: id).first
    account.activities + account.organized_activities
  end
end
