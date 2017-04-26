require_relative './spec_helper'

describe 'Testing unit level properties of accounts' do
  before do
    Account.dataset.destroy
    Activity.dataset.destroy

    @original_password = 'mypassword'
    @account = CreateAccount.call(username: 'xray', email: 'xray@nthu.edu.tw',
                                  password: @original_password)
  end

  it 'HAPPY: should hash the password' do
    _(@account.password_hash).wont_equal @original_password
  end

  it 'HAPPY: should re-salt the password' do
    hashed = @account.password_hash
    @account.password = @original_password
    @account.save
    _(@account.password_hash).wont_equal hashed
  end
end
