require 'rails_helper'

describe CreateConnectionWorker do
  let!(:user) { create(:user) }
  let(:ip_address) { '192.168.1.1' }

  it 'should create new connection record' do
    expect { CreateConnectionWorker.new.perform(user.id, ip_address) }.to change(Connection, :count).by(1)
  end
end
