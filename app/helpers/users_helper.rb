module UsersHelper

  # Returns the Gravatar(http://gravatar.com/) for the given user.
  def gravatar_for(user, option={})
    option[:size] ||= 80

    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar", size: "#{option[:size]}x#{option[:size]}")
  end
end
