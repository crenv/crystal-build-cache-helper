# coding: utf-8

require_relative 'formula'

class FormulaLoader
  attr_reader :formulas

  def initialize(folder)
    @formulas = []

    Dir.glob(File.join(folder, '*')) do |formula|
      load formula

      formula = nil
      Object.class_eval do
        klass      = const_get(:CrystalLang)
        sha256     = klass.sha256
        klass_name = "CrystalLang_#{sha256}"

        break if const_defined? klass_name

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
