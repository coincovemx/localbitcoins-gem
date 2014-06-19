require 'spec_helper'
require 'oauth2'

describe 'Client' do
  let(:client) { LocalBitcoins::Client.new(
    client_id: 'CLIENT_ID',
    client_secret: 'CLIENT_SECRET',
    oauth_token: 'ACCESS_TOKEN'
  )}

  describe "#escrows" do
    before do
      stub_get('/api/escrows/', 'escrows.json')
    end

    it 'returns escrows owner of the access token can release' do
      expect { client.escrows }.not_to raise_error

      escrows = client.escrows
      escrows.should be_a Hashie::Mash
      escrows.escrow_list[0].data.buyer_username.should eq "alice"
      escrows.escrow_list[0].data.reference_code.should eq "123"
      escrows.escrow_list[1].data.reference_code.should eq "456"
      escrows.escrow_list[1].actions.release_url.should eq "/api/escrow_release/2/"
    end
  end

  describe "#wallet" do
    before do
      stub_get('/api/wallet/', 'wallet.json')
    end

    it 'Gets information about the token owners wallet balance' do
      expect { client.wallet }.not_to raise_error

      wallet = client.wallet
      wallet.should be_a Hashie::Mash
      # wallet.wallet_list.total.balance.should eq "0.05"
      # wallet .wallet_list.address.should eq "15HfUY9LwwewaWwrKRXzE91tjDnHmye1hc"
    end
  end
end
