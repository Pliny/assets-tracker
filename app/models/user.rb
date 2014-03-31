class User < ActiveRecord::Base

  valid_email_regex = /\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/i

  validates_presence_of :first_name, :last_name
  validates :email, presence: true, :uniqueness => { :case_sensitive => false }, format: { with: valid_email_regex }

  before_save :create_remember_token
  before_save :normalize_name

  has_many :devices

  def self.create_by_full_name full_name
    if full_name.split(' ').length > 1
      first_name = full_name.split(' ')[0..-2].join(' ').titleize
      last_name = full_name.split(' ').last.titleize
    else
      first_name = full_name
      last_name = nil
    end

    temp_email = "#{SecureRandom.hex(3)}@#{ENV['EMAIL_SERVER']}"
    User.create(full_name: full_name, first_name: first_name, last_name: last_name, email: temp_email)
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

  def normalize_name
    if self.full_name.nil? || self.first_name_changed? || self.last_name_changed?
      self.full_name = "#{self.first_name} #{self.last_name}"
    elsif self.first_name.nil? || self.last_name.nil? || self.full_name_changed?
      self.first_name = self.full_name.split(' ')[0..-2].join(' ')
      self.last_name = self.full_name.split(' ').last
    end

    self.full_name  = self.full_name.strip.titleize
    self.first_name = self.first_name.strip.titleize
    self.last_name  = self.last_name.strip.titleize unless self.last_name.nil?
  end
end
