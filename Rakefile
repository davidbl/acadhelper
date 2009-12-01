require 'rubygems'
require 'spec/rake/spectask'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s| 
  s.name = "acadhelper"
  s.version = "0.5.1"
  s.author = "David K Blackmon"
  s.email = "davidkblackmon@gmail.com"
  s.homepage = "http://github.com/davidbl/acadhelper"
  s.date = %q{2009-12-1}
  s.platform = Gem::Platform::RUBY
  s.description = "AcadHelper - easy access to AutoCAD Managed API via IronRuby"
  s.summary = "Wrappers and helpers for accessing the AutoCAD Managed .Net API with Ruby code using IronRuby"
  s.files = FileList["{lib,examples,spec}/**/*"].to_a
  s.files= s.files.delete_if {|file| file.match(/\.bak/)} 
  s.requirements << 'none'
  s.require_path = "lib"
  s.has_rdoc = true
  s.extra_rdoc_files = %w[README.txt]
end
 
Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.need_zip = true 
end