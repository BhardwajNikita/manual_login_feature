module UserAuthConcern
    extend ActiveSupport::Concern
  
    included do
      attr_accessor :password
  
      validates_uniqueness_of :email, format: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      validates :first_name, :presence => true
      validates :last_name, :presence => true
      validates :password, :presence => true, format: {
        with: /\A(?=.*?[A-Z])(?=(.*[a-z]){1,})(?=(.*[\d]){1,})(?=(.*[\W]){1,})(?!.*\s).{8,15}\z/,
        message: "must contain atleast 1 number, 1 lowercase character, 1 uppercase character, 1 special character and no spaces allowed. Allowed special characters are `~!@#$%^&*-+=" },
                confirmation: true, length: { minimum: 8, maximum: 15 }, on: :create
      before_validation :check_password_validation, if: :password_present?
  
      def password_present?
        !password.blank?
      end
  
      def update_encrypted_password
        if self.password.present?
          self.encrypted_password = PasswordHelper::update(self.password)
        end
      end
  
      def check_password_validation
        if password.present?
          unless self.password =~ /\A^(?=.*?[A-Z])(?=(.*[a-z]){1,})(?=(.*[\d]){1,})(?=(.*[\W]){1,})(?!.*\s).{8,15}\z/
            self.errors.add(:password, "must contain atleast 1 lowercase character, 1 uppercase character, 1 special character, number is also required and no spaces allowed. Allowed special characters are `~!@#$%^&*-+=")
          end
          if self.password.length < 8
            self.errors.add(:password, "length is too short(minimum is 8 characters)")
          end
          if self.password.length > 15
            self.errors.add(:password, "length is too long(maximum is 15 characters)")
          end
        end
        throw(:abort) unless self.errors.blank?
        update_encrypted_password
      end
  
    end
  end