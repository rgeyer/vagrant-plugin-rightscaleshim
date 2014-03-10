Gem::Specification.new do |gem|
  gem.name = "vagrant-rightscaleshim"
  gem.version = "1.0.2"
  gem.homepage = "https://github.com/rgeyer/vagrant-plugin-rightscaleshime"
  gem.license = "MIT"
  gem.summary = %Q{Allows RightScale ServerTemplate development to be performed primarily within Vagrant}
  gem.description = gem.summary
  gem.email = "ryan.geyer@rightscale.com"
  gem.authors = ["Ryan J. Geyer"]

  gem.files = Dir.glob("{lib,locales}/**/*") + ["LICENSE.txt", "README.md"]
end
