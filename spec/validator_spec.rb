require 'epi_doc_validator/validator'

RSpec.describe EpiDocValidator::Validator do
  subject(:validator) { EpiDocValidator::Validator.new }

  before do
    allow(validator).to receive(:__dir__) { File.join(__dir__, 'foo', 'bar') }
  end

  its(:versions) { is_expected.to eq(['8.10', '9.1', 'dev', 'latest']) }
end
