class Expense < ActiveRecord::Base
  attr_accessible :label_id

  belongs_to :user, class_name: "User"
  belongs_to :label, class_name: "Label"

  validates :user_id, presence: true
  validates :label_id, presence: true
end
