require "spec_helper"

RSpec.describe Approval::Comment, type: :model do
  it { is_expected.to belong_to(:request).class_name("Approval::Request").inverse_of(:comments) }
  it { is_expected.to belong_to(:user).class_name("User") }

  it { is_expected.to validate_presence_of(:content) }
  it { is_expected.to validate_length_of(:content).is_at_most(Approval.config.comment_maximum) }
end
