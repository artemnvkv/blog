require 'rails_helper'

RSpec.describe ConnectionsQuery do
  describe '#ip_list' do
    subject(:ip_list) { described_class.new.ip_list }

    before do
      create_list(:user, 2) do |user|
        create(:connection, ip_address: '192.168.1.1', user: user)
      end
    end

    it 'should returns IP list' do
      expect(ip_list.size).to eq(1)
    end
  end
end
