#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require 'octokit'
require 'json'
require 'deep_merge'

require_relative './lib/brew/formula_loader'
require_relative './lib/github/brew_repository'
require_relative './lib/github/crystal_repository'

TOKEN = ENV['GITHUB_ACCESS_TOKEN']

brew_repository = BrewRepository.new(token: TOKEN, save_path: 'tmp/formula')
brew_repository.download

formula_loader     = FormulaLoader.new('tmp/formula')
crystal_repository = CrystalRepository.new(token: TOKEN)

assets = {}

assets.deep_merge! crystal_repository.assets
assets.deep_merge! formula_loader.assets

puts JSON.pretty_generate(assets)
