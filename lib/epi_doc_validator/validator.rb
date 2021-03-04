require_relative './sem_ver'

module EpiDocValidator
  class Validator
    def initialize
    end

    private

    def sort_schema_versions(versions)
    end

    def schema_path(file)
      File.expand_path(File.join('../../vendor/schema/', file), __FILE__)
    end

    def schema_versions
      @schema_versions ||= SemVer.sort(Dir.children(schema_path('')))
    end

    def read_schema_file(file)
      File.read(schema_path(file))
    end
  end
end
