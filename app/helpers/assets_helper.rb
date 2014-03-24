module AssetsHelper

  def display_location in_house
    in_house == true ? "In House" : "Unknown"
  end
end

