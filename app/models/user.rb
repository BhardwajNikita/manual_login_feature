class User < ApplicationRecord
    include UserAuthConcern

    def self.authenticate(email, pass)
        user = User.where('lower(email) = ?', email.downcase).first
        return user if user && PasswordHelper::check(pass, user.encrypted_password)
        nil
    end

end
