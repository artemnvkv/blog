require 'rails_helper'

RSpec.describe Connection, type: :model do
  describe 'associations check' do
    it { should belong_to :user }
  end
end
