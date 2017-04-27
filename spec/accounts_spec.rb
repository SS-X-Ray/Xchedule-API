require_relative './spec_helper'

describe 'Testing unit level properties of accounts' do
  before do
    Activity.dataset.destroy
    Account.dataset.destroy

    @original_password = 'mypassword'
    acc_info = { username: 'xray', email: 'xray@nthu.edu.tw',
                 password: @original_password }
    @account = CreateAccount.call(acc_info)
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
