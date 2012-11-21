$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "index_helper/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "index_helper"
  s.version     = IndexHelper::VERSION
  s.authors     = ["Diego Steiner"]
  s.email       = ["diego.steiner@u041.ch"]
  s.homepage    = ""
  s.summary     = ""
  s.description = ""

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
end
