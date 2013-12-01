atom_feed(language: 'ja-JP', root_url: request.url,
          url: request.url, id: request.url) do |feed|
  feed.title "Page #{params[:page] || 1} of #{@user.email}"
  feed.updated Time.now
  feed.author { |author| author.name(@user.email) }

  @microposts.each do |micropost|
    feed.entry(micropost, id: micropost.id,
               published: micropost.created_at, updated: micropost.updated_at) do |item|
      item.title(micropost.content)
      item.content(micropost.content, type: :text)
      item.author { |author| author.name(@user.email) }
    end
  end
end
