# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tenacity/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'tenacity'
  s.license = 'MIT'
  s.version = Tenacity::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['John Wood']
  s.email = %w(john@johnpwood.net)
  s.homepage = 'http://github.com/jwood/tenacity'
  s.summary = 'A database client independent way of specifying simple relationships between models backed by different databases.'
  s.description = 'Tenacity provides a database client independent way of specifying simple relationships between models backed by different databases.'

  s.rubyforge_project = 'tenacity'

  s.required_rubygems_version = '>= 1.3.6'

  s.add_runtime_dependency 'activesupport', '>= 2.3'

  s.add_development_dependency 'bundler', '>= 1.0.0'
  s.add_development_dependency 'rake', '>= 0.8.7'
  s.add_development_dependency 'shoulda', '~> 2.11.3'
  s.add_development_dependency 'mocha', '~> 0.9.10'
  s.add_development_dependency 'yard', '~> 0.6.4'

  # Relational DBs
  s.add_development_dependency 'sqlite3', '~> 1.3'
  s.add_development_dependency 'activerecord', '~> 3.1'

  # MongoDB
  s.add_development_dependency 'mongo', '~> 1.6.2'
  s.add_development_dependency 'bson_ext', '~> 1.6.2'
  s.add_development_dependency 'mongoid', '~> 3.0.0'

  s.files = `git ls-files`.split("\n")
  s.executables = `git ls-files`.split("\n").map { |f| f =~ /^bin\/(.*)/ ? $1 : nil }.compact
  s.require_path = 'lib'
end

