require_relative './sem_ver'

module EpiDocValidator
  class Validator
    def initialize
    end

    def versions
      schemas.keys
    end

    private

    def schema_path(file)
      File.expand_path(File.join('../../vendor/schema/', file), __dir__)
    end

    def schemas
      return @schemas if @schemas

      versions = SemVer.sort(Dir.children(schema_path('')))
      @schemas = versions.each_with_object({}) { |n, m| m[n] = nil }
    end

    def read_schema_file(file)
      @schemas[file] ||= File.read(schema_path(file))
    end
  end
end
