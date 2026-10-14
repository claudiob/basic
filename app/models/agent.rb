# An agent, also known as admin.
class Agent < ApplicationRecord
  include Emailable, Recoursive, Searchable

  validates :email, presence: true, uniqueness: true
  has_many :chats, dependent: :destroy

  # The agent's email, wherever an agent is shown.
  def to_s = email
end
