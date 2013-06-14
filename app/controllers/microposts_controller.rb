class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :direct_message, only: :create
  before_action :correct_user, only: :destroy

  def index
  end

  def create
    if direct_message?
      @message = current_user.messages.build(content: @content, recipient: @recipient)
      if @message.save
        flash[:success] = "Message sent!"
        redirect_to root_url
      else
        @feed_items = []
        render 'static_pages/home'
      end
    else
      @micropost = current_user.microposts.build(micropost_params)
      if @micropost.save
        flash[:success] = "Micropost created!"
        redirect_to root_url
      else
        @feed_items = []
        render 'static_pages/home'
      end
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content)
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_url if @micropost.nil?
  end

  def direct_message
    if params[:micropost][:content].match /\AD\s(\d+)\s+(.+)\Z/
      recipient_id = $1
      @recipient = User.find_by id: recipient_id
      @content = $2
    end
  end

  def direct_message?
    @recipient && @content
  end
end
