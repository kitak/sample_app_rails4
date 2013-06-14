class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :recipient, class_name: 'User'
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  validates :recipient_id, presence: true
  validate do
    return if recipient.nil? || user.nil?
    errors.add(:user, "can't send message to self") if self.recipient.id == self.user.id
  end

end
