# coding: utf-8

require 'brew/extend/module'

class BuildOptions
  def with?(val)
  end
end

class Bottle < Hash
  attr_rw :revision
  attr_rw :rebuild

  def sha256(val)
    digest, tag = val.shift
    self[tag] = digest
  end
end

class Formula
  class << self
    attr_rw :desc
    attr_rw :homepage
    attr_rw :revision
    attr_rw :url
    attr_rw :sha256
    attr_rw :head

    def stable(&block)
      instance_eval(&block) if block_given?
    end

    def patch
    end

    def bottle(&block)
      @bottle ||= Bottle.new
      @bottle.instance_eval(&block) if block_given?
      @bottle
    end

    def option(name, description)
    end

    def depends_on(dep)
    end

    def build
      @build ||= BuildOptions.new
    end

    def resource(name, &block)
    end

    def test(&block)
    end

    def version
      /archive\/([0-9\.]+)\.tar\.gz/ =~ @url
      $1
    end

    def bottle_urls
      crystal_version = self.version

      bottle.keys.map { |osx_name|
        [
          "darwin-x64-#{osx_name}",
          "https://homebrew.bintray.com/bottles/crystal-lang-#{crystal_version}.#{osx_name}.bottle.tar.gz"
        ]
      }.to_h
    end
  end
end
