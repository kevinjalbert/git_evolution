$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

Bundler.require(:test)
Bundler.require(:development)

Dir.glob(Dir.pwd + '/spec/support/**/*.rb') { |file| require file }

require 'git_evolution/initialize'

def fixture(file_name)
  File.read([Dir.pwd, 'spec', 'fixtures', file_name].join('/'))
end

RSpec.configure do |c|
  c.include RepositoryHelper
end
