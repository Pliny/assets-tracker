class HardwareVersion < ActiveRecord::Base

  validates_presence_of :name, :project
  validates_uniqueness_of :name, scope: :project, case_sensitive: false

  def display
    "%-8s -- %6s" % [self.project.titleize, self.name]
  end
end
