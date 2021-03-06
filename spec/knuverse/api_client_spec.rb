require 'spec_helper'

describe KnuVerse::Knufactor::APIClient do
  let(:knuverse_base_url) { 'https://cloud.knuverse.com/api/v1/' }
  context 'without a configuration' do
    subject { KnuVerse::Knufactor::APIClient.instance }

    describe '#authenticated?' do
      it 'should raise an exception' do
        error_class = KnuVerse::Knufactor::Exceptions::APIClientNotConfigured
        expect { subject.authenticated? }.to raise_error(error_class)
      end
    end

    describe '#refresh_auth_bearer' do
      it 'should raise an exception' do
        error_class = KnuVerse::Knufactor::Exceptions::APIClientNotConfigured
        expect { subject.refresh_auth_bearer }.to raise_error(error_class)
      end
    end
  end

  context 'under nominal conditions' do
    subject do
      configured_client = KnuVerse::Knufactor::APIClient.instance
      configured_client.configure(
        apikey: 'cb04b87d38ae2b13a1da477efd2e41ea',
        secret: '3b5270c288eaf46e32de0b58017cbe48'
      )
      configured_client
    end

    describe '#api_uri' do
      it 'should provide a full API uri' do
        expect(subject.api_uri).to eq(URI.parse(knuverse_base_url))
      end
    end

    describe '#json_headers' do
      it 'should request a valid content type' do
        expect(subject.json_headers).to eq(content_type: :json, accept: :json)
      end
    end
  end
end
