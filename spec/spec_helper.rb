$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

Bundler.require(:test)
Bundler.require(:development)

Dir.glob(Dir.pwd + '/spec/support/**/*.rb') { |file| require file }

require 'git_evolution/initialize'

RSpec.configure do |c|
  c.include RepositoryHelper
end
