require 'spec_helper'

module Penumbra
  describe Catalog do
    let(:path) {File.expand_path(File.join('.', 'tmp', 'catalog'))}
    let(:catalog) {described_class.new(path)}
    let(:index_name_1) {'index_1'}
    let(:key) {:key}
    let(:value) {'value'}
    let(:index_1) {catalog[index_name_1]}

    before(:each) do
      FileUtils.rm_rf(path)
    end

    after(:each) do
      FileUtils.rm_rf(path)
    end

    it 'has a path reader' do
      expect(catalog).to respond_to(:path)
      expect(catalog.path).to eql(path)
    end

    describe '#open' do
      it 'creates the provided path' do
        expect(File.exist?(path)).to eql(false)
        catalog.open
        expect(File.exist?(path)).not_to eql(false)
      end
    end

    describe '#[]' do
      it 'is the index for the provided name' do
        expect(catalog).
          to receive(:index_for).with(index_name_1).and_call_original

        catalog[index_name_1]
      end
    end

    describe '#indexes' do
      let(:indexes) {catalog.indexes}

      it 'is a Hash' do
        expect(catalog.indexes).to be_a(Hash)
      end

      it 'is empty if no indexes have been used' do
        expect(catalog.indexes).to eql({})
      end

      it 'is all indexes that have been used' do
        catalog[index_name_1]
        expect(indexes.keys).to include(index_name_1.to_s)
        expect(indexes[index_name_1]).to be_a(Penumbra::Index)
      end
    end

    describe '#put' do
      it 'indexes the given key and value for the specified index' do
        expect(index_1).to receive(:put).with(key, value).and_call_original

        catalog.put(index_name_1, key, value)
      end
    end

    describe '#get' do
      it 'gets the indexed value for the given key and index' do
        expect(index_1).to receive(:get).with(key).and_call_original

        catalog.get(index_name_1, key)
      end
    end

    describe '#keys_for' do
      it 'is the keys for the given index' do
        expect(index_1).to receive(:keys).and_call_original

        catalog.keys_for(index_name_1)
      end
    end

    describe '#values_for' do
      it 'is the values for the given index' do
        expect(index_1).to receive(:values).and_call_original

        catalog.values_for(index_name_1)
      end
    end

    describe '#close' do
      it 'raises an error if the catalog is not open' do
        expect {catalog.close}.to raise_error(Penumbra::Catalog::NotOpenError)
        catalog.open
        expect {catalog.close}.not_to raise_error
      end

      it 'closes the indexes' do
        expect(catalog[:index_1]).to receive(:close).and_call_original
        expect(catalog[:index_2]).to receive(:close).and_call_original

        catalog.open
        catalog.close
      end
    end

    describe '#destroy' do
      it 'removes the catalog path' do
        catalog.open
        catalog.close
        
        expect(File.exist?(path)).to eql(true)
        catalog.destroy
        expect(File.exist?(path)).to eql(false)
      end
    end
  end
end
