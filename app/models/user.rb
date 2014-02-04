class User < ActiveRecord::Base

   valid_email_regex = /\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/i

   validates_presence_of :first_name
   validates :email, presence: true, :uniqueness => { :case_sensitive => false }, format: { with: valid_email_regex }

  before_save :create_remember_token

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
