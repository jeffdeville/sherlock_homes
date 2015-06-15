require 'spec_helper'

RSpec.describe SherlockHomes::Downloader, vcr: true do

  describe '#store' do
    context 'with a valid url' do
      after { File.delete(result) }

      Given(:uri) { 'http://rubyonrails.org/images/rails.png' }
      When(:result) { subject.class.store(uri) }
      Then { result.is_a? File }
      And { expect(result.path).to end_with ".png"}
    end

    context 'with a invalid url' do
      Given(:uri) { 'http://www.google.com/image.png' }
      When(:result) { subject.class.store(uri) }
      Then {  expect(result).to have_failed(OpenURI::HTTPError) }
    end
  end

  describe '.extension' do
    context 'with png' do
      Given(:file_path) { File.dirname(__FILE__) + '/../fixtures/files/file.png' }
      When(:result) { subject.extension(file_path) }
      Then {  expect(result).to be_eql('png') }
    end

    context 'with jpg' do
      Given(:file_path) { File.dirname(__FILE__) + '/../fixtures/files/file.jpg' }
      When(:result) { subject.extension(file_path) }
      Then {  expect(result).to be_eql('jpg') }
    end

    context 'with gif' do
      Given(:file_path) { File.dirname(__FILE__) + '/../fixtures/files/file.gif' }
      When(:result) { subject.extension(file_path) }
      Then {  expect(result).to be_eql('gif') }
    end

  end

end
