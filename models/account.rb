# Holds and persists an account's information
class Account < BaseAccount
  def password=(new_password)
    new_salt = SecureDB.new_salt
    hashed = SecureDB.hash_password(new_salt, new_password)
    self.salt = new_salt
    self.password_hash = hashed
  end

  def password?(try_password)
    try_hashed = SecureDB.hash_password(salt, try_password)
    try_hashed == password_hash
  end
end
