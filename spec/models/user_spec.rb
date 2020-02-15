require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations check' do
    it { should have_many :posts }
    it { should have_many :connections }
  end
end
