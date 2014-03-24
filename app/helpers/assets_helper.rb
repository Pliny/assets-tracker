module AssetsHelper

  def display_location in_house
    in_house == true ? "In House" : "Unknown"
  end

  def get_image_from user
    user.google_image_url || "default_user_image.png"
  end
end

