module UsersHelper
  DEFAULT_GRAVATAR_IMAGE_SIZE = 80

  # Returns the Gravatar(http://gravatar.com/) for the given user.
  def gravatar_for(user, option={})
    option[:size] ||= DEFAULT_GRAVATAR_IMAGE_SIZE 

    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar", size: "#{option[:size]}x#{option[:size]}")
  end
end
