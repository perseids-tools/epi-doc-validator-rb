require_relative 'lib/epi_doc_validator/version'

Gem::Specification.new do |spec|
  spec.name          = 'epi_doc_validator'
  spec.version       = EpiDocValidator::VERSION
  spec.authors       = ['Perseids Project']
  spec.email         = ['perseids@tufts.edu']

  spec.summary       = 'Library for validating EpiDoc XML'
  spec.description   = 'Library for validating EpiDoc XML'
  spec.homepage      = 'https://github.com/perseids-tools/epi-doc-validator-rb'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4')

  spec.metadata['homepage_uri'] = 'https://github.com/perseids-tools/epi-doc-validator-rb'
  spec.metadata['source_code_uri'] = 'https://github.com/perseids-tools/epi-doc-validator-rb'
  spec.metadata['changelog_uri'] = 'https://github.com/perseids-tools/epi-doc-validator-rb/releases'

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|bin|scripts)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.platform = 'java'

  spec.add_dependency 'nokogiri', '~> 1.10'
end
