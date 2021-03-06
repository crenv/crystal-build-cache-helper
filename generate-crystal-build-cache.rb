#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'octokit'
require 'json'
require 'deep_merge'

require 'brew/formula_loader'
require 'github/brew_repository'
require 'github/crystal_repository'

TOKEN = ENV['GITHUB_ACCESS_TOKEN']

brew_repository = BrewRepository.new(token: TOKEN, save_path: 'tmp/formula')
brew_repository.download

formula_loader     = FormulaLoader.new('tmp/formula')
crystal_repository = CrystalRepository.new(token: TOKEN)

assets_hash = {}

assets_hash.deep_merge! crystal_repository.assets
assets_hash.deep_merge! formula_loader.assets

assets = assets_hash.map do |key, value|
  { tag_name: key, assets: value }
end

puts JSON.pretty_generate(assets)
