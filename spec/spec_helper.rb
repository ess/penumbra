require 'simplecov'
SimpleCov.coverage_dir 'coverage/spec'
SimpleCov.start do
  add_filter '/spec/'
  add_group 'Libraries', 'lib'
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'penumbra'
