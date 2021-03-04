require 'epi_doc_validator/sem_ver'

RSpec.describe EpiDocValidator::SemVer do
  it 'correctly sorts a list of semantic versions' do
    versions = [
      '0.4.1',
      '0.3',
      '1.0',
      '0.4.1-rc2',
      '0.4.1-rc1',
      'latest',
      'dev',
      '0.4',
      '0.21.2',
      '10.1',
    ]

    sorted = [
      '0.3',
      '0.4',
      '0.4.1',
      '0.4.1-rc1',
      '0.4.1-rc2',
      '0.21.2',
      '1.0',
      '10.1',
      'dev',
      'latest',
    ]

    expect(EpiDocValidator::SemVer.sort(versions)).to eq(sorted)
  end
end
