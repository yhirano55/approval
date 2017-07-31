require "spec_helper"

RSpec.describe Approval::Config do
  let(:config) { described_class.new }

  describe "#permit_to_respond_to_own_request?" do
    subject { config.permit_to_respond_to_own_request? }
    it { is_expected.to eq false }
  end
end
