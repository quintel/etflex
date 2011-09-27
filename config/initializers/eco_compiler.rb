module Stitch
  class EcoCompiler < Compiler
    extensions :eco

    enabled begin
      require 'eco'
      true
    rescue LoadError
      false
    end

    def compile(path)
      "module.exports = #{Eco.compile(File.read(path))}"
    end
  end
end
