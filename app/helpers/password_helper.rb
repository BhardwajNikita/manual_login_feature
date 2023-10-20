require 'digest/sha2'

# This module contains functions for hashing and storing passwords
module PasswordHelper

  # Generates a new salt and rehashes the password
  def PasswordHelper.update(password)
    salt = self.salt
    hash = self.hash(password, salt)
    self.store(hash, salt)
  end

  # Checks the password against the stored password
  def PasswordHelper.check(password, store)
    hash = self.get_hash(store)
    salt = self.get_salt(store)
    if self.hash(password, salt) == hash
      true
    else
      false
    end
  end

  def PasswordHelper.check_encrypted_password(password, stored_password)
    stored_password_hash = self.get_hash(stored_password)
    hash = self.get_hash(password)
    if stored_password_hash.eql?(hash)
      true
    else
      false
    end
  end

  protected

  # Generates a psuedo-random 64 character string

  def PasswordHelper.salt
    salt = ""
    64.times { salt << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61))).chr }
    salt
  end

  # Generates a 128 character hash
  def PasswordHelper.hash(password, salt)
    Digest::SHA512.hexdigest("#{password}:#{salt}")
  end

  # Mixes the hash and salt together for storage
  def PasswordHelper.store(hash, salt)
    hash + salt
  end

  # Gets the hash from a stored password
  def PasswordHelper.get_hash(store)
    store[0..127]
  end

  # Gets the salt from a stored password
  def PasswordHelper.get_salt(store)
    store[128..192]
  end
end