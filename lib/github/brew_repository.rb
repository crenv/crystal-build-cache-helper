# coding: utf-8

require 'octokit'

class BrewRepository
  REPOSITORY   = 'Homebrew/homebrew-core'
  FORMULA_PATH = 'Formula/crystal-lang.rb'

  def initialize(**options)
    @save_path = options[:save_path]

    Octokit.configure do |c|
      c.access_token  = options[:token]
      c.auto_paginate = true
    end
  end

  def download
    commits = Octokit.commits(REPOSITORY, path: 'Formula/crystal-lang.rb')

    FileUtils.rm_rf(@save_path)
    FileUtils.mkdir_p(@save_path)

    commit = commits.each do |commit|
      options = {
        path: 'Formula/crystal-lang.rb',
        ref: commit.sha,
        accept: 'application/vnd.github.v3.raw',
      }
			contents = Octokit.contents(REPOSITORY, options)
      File.write(File.join(@save_path, "#{commit.sha}.rb"), contents)
    end

    puts
  end
end
