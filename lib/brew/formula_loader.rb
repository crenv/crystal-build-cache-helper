# coding: utf-8

require 'brew/formula'

class FormulaLoader
  attr_reader :formulas

  def initialize(folder)
    @formulas = []

    Dir.glob(File.join(folder, '*')).sort.each do |formula|
      load formula

      formula = nil
      Object.class_eval do
        klass      = const_get(:CrystalLang)
        version    = klass.version.gsub('.', '')
        klass_name = "CrystalLang_v#{version}"

        break if klass.bottle_urls.length.zero?

        if const_defined? klass_name
          remove_const(:CrystalLang)
          break
        end

        const_set(klass_name, klass.clone)
        remove_const(:CrystalLang)

        formula = const_get(klass_name)
      end

      @formulas << formula if formula
    end
  end

  def assets
    @formulas.map { |formula|
      [ formula.version, formula.bottle_urls ]
    }.to_h
  end
end
