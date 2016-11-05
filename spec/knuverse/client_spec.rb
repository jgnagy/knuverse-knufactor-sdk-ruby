require 'spec_helper'

describe KnuVerse::Knufactor::Client do
  let(:knuverse_base_url) { 'https://cloud.knuverse.com/api/v1/' }
  context 'under nominal conditions' do
    subject do
      KnuVerse::Knufactor::Client.new(
        apikey: 'test',
        secret: 'test1234',
        account:  12_345_678_900
      )
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
