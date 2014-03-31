class HardwareVersion < ActiveRecord::Base

  validates_presence_of :name, :project
  validates_uniqueness_of :name, scope: :project, case_sensitive: false

  def display
    "#{self.project.titleize} -- #{self.name}"
  end
end
