require 'epi_doc_validator/validator'

RSpec.describe EpiDocValidator::Validator do
  let(:valid_doc) { fixture('valid_doc.xml') }
  let(:invalid_doc) { fixture('invalid_doc.xml') }
  let(:valid9) { fixture('valid_9.xml') }

  subject(:validator) { EpiDocValidator::Validator.new }

  before do
    allow(validator).to receive(:__dir__) { File.join(__dir__, 'foo', 'bar') }
  end

  its(:versions) { is_expected.to eq(['8.23', '9.1', 'dev', 'latest']) }

  describe '#errors' do
    it 'returns errors when the XML does not validate against the schema' do
      expect(validator.errors(invalid_doc)).to eq([
        '52:0: ERROR: Did not expect element ab there',
        '53:0: ERROR: Element div has extra content: ab',
        '51:0: ERROR: Did not expect element div there',
        '51:0: ERROR: Expecting element q, got div',
        '51:0: ERROR: Element body failed to validate content',
      ])
    end

    it 'returns no errors when the XML validates against the schema' do
      expect(validator.errors(valid_doc)).to eq([])
    end

    it 'validates against the version given by the version: argument' do
      expect(validator.errors(valid9, version: '9.1')).to eq([])
      expect(validator.errors(valid9, version: '8.23')).to eq([
        '52:0: ERROR: Did not expect element sp there',
        '53:0: ERROR: Element div has extra content: sp',
        '51:0: ERROR: Did not expect element div there',
        '51:0: ERROR: Element body failed to validate content',
      ])
    end

    it 'returns errors when the XML is malformed' do
      expect(validator.errors('zoboomafoo')).to eq(["1:1: FATAL: Start tag expected, '<' not found"])
    end

    it 'raises an exception when the version does not exist' do
      expect do
        validator.errors(valid_doc, version: 'nonexistent')
      end.to raise_error(EpiDocValidator::VersionNotFoundError)
    end
  end

  describe '#valid?' do
    it 'returns false when the XML does not validate against the schema' do
      expect(validator.valid?(invalid_doc)).to be_falsey
    end

    it 'returns true when the XML validates against the schema' do
      expect(validator.valid?(valid_doc)).to be_truthy
    end

    it 'validates against the version given by the version: argument' do
      expect(validator.valid?(valid9, version: '9.1')).to be_truthy
      expect(validator.valid?(valid9, version: '8.23')).to be_falsey
    end

    it 'returns false when the XML is malformed' do
      expect(validator.valid?('zoboomafoo')).to be_falsey
    end

    it 'raises an exception when the version does not exist' do
      expect do
        validator.valid?(valid_doc, version: 'nonexistent')
      end.to raise_error(EpiDocValidator::VersionNotFoundError)
    end
  end
end
