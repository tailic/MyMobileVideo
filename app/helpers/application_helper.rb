module ApplicationHelper
  def get_asset_thumb(path, filename, size)
    path = path.gsub(/#{filename}\??[0-9]*/,'')
    thumb_size = case size
      when "thumb" then "thumb135x100.jpg"
      when "medium" then "thumb290x200.jpg"
      when "large" then "thumb600x380.jpg"
    end
    return path + thumb_size
  end  
end
