require 'rubygems'
require 'spec/rake/spectask'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s| 
  s.name = "acadhelper"
  s.version = "0.5.0"
  s.author = "David K Blackmon"
  s.email = "davidkblackmon@gmail.com"
  s.homepage = "http://github.com/davidbl/IronRuby-Autocad-Helper"
  s.date = %q{2009-11-10}
  s.platform = Gem::Platform::RUBY
  s.description = "AcadHelper - easy access to AutoCAD Managed API via IronRuby"
  s.summary = "Wrappers and helpers for accessing the AutoCAD Managed .Net API with Ruby code using IronRuby"
  s.files = FileList["{bin,lib}/**/*"].to_a
  s.requirements << 'none'
  s.require_path = "lib"
  s.has_rdoc = true
  s.extra_rdoc_files = %w[README.txt]
end
 
Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.need_zip = true 
end