module EpiDocValidator
  class SemVer
    def self.sort(versions)
      versions.map { |v| new(v) }.sort.map(&:semver)
    end

    def initialize(semver)
      @semver = semver

      numbers, @patch = *semver.split('-')

      if semver.match?(/\A\d/)
        @components = numbers.split('.').map(&:to_i)
      end
    end

    def <=>(other)
      return 0 if semver == other.semver

      return compare_strings(other) if string? || other.string?

      compare_components(other)
    end

    attr_reader :semver

    protected

    attr_reader :components

    def patch
      @patch || ''
    end

    def string?
      components.nil?
    end

    def value_at(index)
      components[index] || 0
    end

    private

    def compare_strings(other)
      return 1 if string? && !other.string?
      return -1 if !string? && other.string?

      semver <=> other.semver if string? && other.string?
    end

    def compare_components(other, index = 0)
      return patch <=> other.patch if !components[index] && !other.components[index]
      return -1 if value_at(index) < other.value_at(index)
      return 1 if value_at(index) > other.value_at(index)

      compare_components(other, index + 1)
    end
  end
end
