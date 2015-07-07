require 'penumbra/version'
require 'penumbra/catalog'
require 'penumbra/index'

module Penumbra
  def self.catalog(path)
    Catalog.new(path)
  end

  def self.index(path)
    Index.new(path)
  end
end
