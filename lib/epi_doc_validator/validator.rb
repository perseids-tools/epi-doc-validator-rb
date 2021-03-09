require 'nokogiri'

require_relative './sem_ver'
require_relative './errors'

module EpiDocValidator
  class Validator
    def versions
      schemas.keys
    end

    def errors(xml, version: 'latest')
      doc = Nokogiri::XML(xml)

      return doc.errors.map(&:to_s) unless doc.errors.empty?

      rng_for(version).validate(Nokogiri::XML(xml)).map(&:to_s)
    end

    def valid?(xml, version: 'latest')
      errors(xml, version: version).empty?
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

    def rng_for(version)
      raise VersionNotFoundError unless schemas.member?(version)

      unless schemas[version]
        rng = File.read(schema_path(File.join(version, 'tei-epidoc.rng')))
        schemas[version] = Nokogiri::XML(rng)
      end

      Nokogiri::XML::RelaxNG.from_document(schemas[version])
    end
  end
end
