require 'spec_helper'

module Penumbra
  describe Index do
    let(:path) {File.expand_path(File.join('.', 'tmp', '.index'))}
    let(:index) {described_class.new(path)}
    let(:key) {:blah}
    let(:value) {'a shadow falls'}

    before(:each) do
      FileUtils.rm_rf(path)
    end

    after(:each) do
      FileUtils.rm_rf(path)
    end

    it 'has a path reader' do
      expect(index).to respond_to(:path)
      expect(index.path).to eql(path)
    end

    describe '#keys' do
      it 'is a collection' do
        expect(index.keys).to respond_to(:each)
      end

      it 'contains all of the indexed keys' do
        expect(index.keys).to be_empty
        index.put(key, value)
        expect(index.keys).to eql([key])
      end
    end

    describe '#values' do
      it 'is a collection' do
        expect(index.values).to respond_to(:each)
      end

      it 'contains all of the indexed values' do
        expect(index.values).to be_empty
        index.put(key, value)
        expect(index.values).to eql([value])
      end
    end

    describe '#get' do
      it 'is nil when the key is unknown' do
        expect(index.keys).not_to include(key)
        expect(index.get(key)).to be_nil
      end

      it 'is the value indexed to the key for a known key' do
        index.put(key, value)
        expect(index.get(key)).to eql(value)
      end
    end

    describe '#put' do
      it 'is the value that was put' do
        expect(index.put(key, value)).to eql(value)
      end

      it 'indexes the key and value' do
        expect(index.get(key)).to be_nil
        index.put(key, value)
        expect(index.get(key)).to eql(value)
      end

      it 'overwrites an existing index' do
        index.put(key, value)
        expect(index.get(key)).to eql(value)

        new_value = 'hour of long shadows'
        index.put(key, new_value)
        expect(index.get(key)).to eql(new_value)
      end
    end

    describe '#db' do
      context 'when the index has not been written to disk' do
        it 'is an empty Hash' do
          expect(index.db).to eql({})
        end
      end

      context 'when the index has been written to disk' do
        let(:data) {{key => value}}
        
        before(:each) do
          file = File.open(path, 'w')
          file.write(Oj.dump(data))
          file.close
        end

        it 'is the existing index' do
          expect(index.db).to eql(data)
        end
      end
    end

    describe '#close' do
      it 'writes the index to disk' do
        expect(File.exist?(path)).to eql(false)
        index.put(key, value)
        index.close
        expect(File.exist?(path)).to eql(true)
        expect(Oj.load(File.read(path))).to eql(index.db)
      end
    end
  end
end
