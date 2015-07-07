require 'oj'

module Penumbra
  class Index
    attr_reader :path

    def initialize(path)
      @path = path
      db
    end

    def keys
      db.keys.sort
    end

    def values
      db.values
    end

    def get(key)
      db[key]
    end

    def put(key, value)
      db[key] = value
    end

    def db
      @db ||= File.exist?(path) ? Oj.load(File.read(path)) : {}
    end

    def close
      file = File.open(path, 'w')
      file.write(Oj.dump(db))
      file.close
    end
  end
end
