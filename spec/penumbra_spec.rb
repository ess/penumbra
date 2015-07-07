require 'spec_helper'

describe Penumbra do
  it 'has a version number' do
    expect(Penumbra::VERSION).not_to be nil
  end

  describe '.catalog' do
    let(:path) {File.expand_path(File.join('.', 'tmp', 'catalog'))}
    let(:catalog) {described_class.catalog(path)}

    before(:each) do
      FileUtils.rm_rf(path)
    end

    after(:each) do
      FileUtils.rm_rf(path)
    end

    it 'is a Catalog' do
      expect(catalog).to be_a(Penumbra::Catalog)
    end

    it 'is scoped to the provided path' do
      expect(catalog.path).to eql(path)
    end
  end

  describe '.index' do
    let(:path) {File.expand_path(File.join('.', 'tmp', 'index'))}
    let(:index) {described_class.index(path)}

    before(:each) do
      FileUtils.rm_rf(path)
    end

    after(:each) do
      FileUtils.rm_rf(path)
    end

    it 'is an Index' do
      expect(index).to be_a(Penumbra::Index)
    end

    it 'is scoped to the provided path' do
      expect(index.path).to eql(path)
    end
  end
end
