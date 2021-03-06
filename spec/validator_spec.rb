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
        '-1:-1: ERROR: unknown element "incorrect" from namespace "http://www.tei-c.org/ns/1.0"',
      ])
    end

    it 'returns no errors when the XML validates against the schema' do
      expect(validator.errors(valid_doc)).to eq([])
    end

    it 'validates against the version given by the version: argument' do
      expect(validator.errors(valid9, version: '9.1')).to eq([])
      expect(validator.errors(valid9, version: '8.23')).to eq([
        '-1:-1: ERROR: attribute "toWhom" not allowed at this point; ignored',
      ])
    end

    it 'returns errors when the XML is malformed' do
      expect(validator.errors('zoboomafoo')).to eq([
        'Content is not allowed in prolog.',
        'Content is not allowed in prolog.',
      ])
    end

    it 'raises an exception when the version does not exist' do
      expect do
        validator.errors(valid_doc, version: 'nonexistent')
      end.to raise_error(EpiDocValidator::VersionNotFoundError)
    end

    it 'returns the same result when called more than once' do
      validator.errors(invalid_doc)
      expect(validator.errors(invalid_doc)).to eq([
        '-1:-1: ERROR: unknown element "incorrect" from namespace "http://www.tei-c.org/ns/1.0"',
      ])
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
