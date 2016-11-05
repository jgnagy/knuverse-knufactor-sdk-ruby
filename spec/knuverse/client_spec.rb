require 'spec_helper'

describe KnuVerse::Knufactor::Client do
  let(:knuverse_base_url) { 'https://cloud.dev.knuverse.com/api/v1/' }
  context 'under nominal conditions' do
    subject do
      KnuVerse::Knufactor::Client.new(
        'https://cloud.dev.knuverse.com',
        username: 'test',
        password: 'test1234',
        account:  12_345_678_900
      )
    end

    describe '#api_uri' do
      it 'should provide a full API uri' do
        expect(subject.api_uri).to eq(URI.parse(knuverse_base_url))
      end
    end

    describe '#using_auth?' do
      it 'should determine if the client is using credentials' do
        expect(subject.using_auth?).to be true
      end
    end
  end
end
