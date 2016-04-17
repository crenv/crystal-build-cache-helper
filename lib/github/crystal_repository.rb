# coding: utf-8

require 'octokit'

class CrystalRepository
  REPOSITORY = 'crystal-lang/crystal'

  def initialize(**options)
    Octokit.configure do |c|
      c.access_token  = options[:token]
      c.auto_paginate = true
    end
  end

  def assets
    print "Download Crystal releases ..."
    STDOUT.flush

    releases = Octokit.releases(REPOSITORY).map { |release|
      [ release[:tag_name], convert_assets(release[:assets]) ]
    }.to_h

    puts
    releases
  end

  private

  def convert_assets(assets)
    linux_x86 = assets.find {|asset| /linux.*i\d86/ === asset[:name] }
    linux_x64 = assets.find {|asset| /linux.*64/    === asset[:name] }
    darwin    = assets.find {|asset| asset[:name].include? 'darwin'  }

    results = Hash.new
    results['linux-x86']  = linux_x86[:browser_download_url]  if linux_x86
    results['linux-x64']  = linux_x64[:browser_download_url]  if linux_x64
    results['darwin-x64'] = darwin[:browser_download_url]     if darwin

    results
  end
end
