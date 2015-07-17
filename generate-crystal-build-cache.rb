#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require 'octokit'
require 'json'

REPO  = 'manastech/crystal'
TOKEN = ENV['GITHUB_ACCESS_TOKEN']

class CrystalBuildCache
  def initialize(repo, token = nil)
    @repo = repo

    Octokit.configure do |c|
      c.access_token = token if token
    end
  end

  def releases
    Octokit.releases(@repo).map do |release|
      {
        :tag_name => release[:tag_name],
        :assets   => convert_assets(release[:assets])
      }
    end
  end

  private

  def convert_assets(assets)
    linux  = assets.find {|asset| asset[:name].include? 'linux'  }
    darwin = assets.find {|asset| asset[:name].include? 'darwin' }

    results = Hash.new
    results['linux-x64']  = linux[:browser_download_url]  if linux
    results['darwin-x64'] = darwin[:browser_download_url] if darwin

    results
  end
end

cache = CrystalBuildCache.new(REPO, TOKEN)
puts JSON.pretty_generate(cache.releases)

# vim: se et ts=2 sw=2 sts=2 ft=ruby :
