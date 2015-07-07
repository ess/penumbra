require 'penumbra/index'

module Penumbra
  class Catalog
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def [](index_name)
      index_for(index_name)
    end

    def indexes
      @indexes ||= {}
    end

    def index_for(index_name)
      index_name = index_name.to_s
      indexes[index_name] ||= Index.new(File.join(path, index_name))
    end

    def put(index_name, key, value)
      index_for(index_name).put(key, value)
    end

    def get(index_name, key)
      index_for(index_name).get(key)
    end

    def keys_for(index_name)
      index_for(index_name).keys
    end

    def values_for(index_name)
      index_for(index_name).values
    end

    def open
      create_path
      @opened = true
    end

    def close
      raise NotOpenError unless open?
      indexes.values.map(&:close)
    end

    def destroy
      remove_path
    end

    private
    def create_path
      FileUtils.mkdir_p(path)
    end

    def open?
      @opened
    end

    def remove_path
      FileUtils.rm_rf(path)
    end

    class NotOpenError < StandardError ; end
  end
end
