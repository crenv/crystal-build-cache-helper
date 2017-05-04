# coding: utf-8

require 'octokit'
require 'retryable'

class BrewRepository
  REPOSITORY   = 'Homebrew/homebrew-core'
  FORMULA_PATH = 'Formula/crystal-lang.rb'

  def initialize(**options)
    @save_path = options[:save_path]
    @per_page  = 30

    Octokit.configure do |c|
      c.access_token  = options[:token]
      c.auto_paginate = false
    end
  end

  def download
    commits = Retryable.retryable do
      Octokit.commits(REPOSITORY, {
        path: 'Formula/crystal-lang.rb',
        per_page: @per_page,
      })
    end

    loop do
      break if commits.size.zero?

      c = Retryable.retryable do
        Octokit.commits(REPOSITORY, {
          path: 'Formula/crystal-lang.rb',
          per_page: @per_page,
          sha: commits.last[:sha]
        })
      end

      break if c.size.zero?
      break if c.last[:sha] == commits.last[:sha]

      commits.concat(c)
    end

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
  end
end
