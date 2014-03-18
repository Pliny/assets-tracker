class Asset < ActiveRecord::Base
  validates_presence_of :serial_no, :user_id
  validates_uniqueness_of :serial_no

  belongs_to :user

  has_paper_trail

  def self.import file
    errors = []

    spreadsheet = open_spreadsheet(file)

    sheet = "AppendList"
    header = spreadsheet.row(2, sheet)

    (3..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]

      next if true == invalid_row?(row)

      asset = Asset.find_by_serial_no(row["Serial No"]) || Asset.new

      user = nil
      if row["Owner"].nil? && ENV['ASSETS_ADMIN'].present?
        user = User.find_by_full_name(ENV['ASSETS_ADMIN']) || User.create_by_full_name!(ENV['ASSETS_ADMIN'])
      elsif row["Owner"].present?
        user = User.find_by_full_name(row["Owner"].strip.titleize) || User.create_by_full_name!(row["Owner"].strip.titleize)
      end

      asset.attributes = {
        serial_no:   row["Serial No"],
        user:        user,
        mac_address: row["MAC"],
        notes:       row["Notes"],
        in_house:    (true if row["In House"].try(:downcase) == 'y')
      }

      asset.save

      if asset.errors.present?
        errors << "Row #{i} in #{sheet} sheet has error '#{asset.errors.full_messages.join(", ")}'"
      end
    end

    if errors.empty?
      return true
    else
      return errors
    end
  end

  private

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".xls"  then  Roo::Excel.new(file.path, file_warning: :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, file_warning: :ignore)
    when ".xlsm" then Roo::Excelx.new(file.path, file_warning: :ignore)
    else raise "Filetype is not supported: #{file.original_filename}"
    end
  end

  def self.invalid_row?(row)
    row.values.reject(&:blank?).empty?
  end
end
