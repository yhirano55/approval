require "spec_helper"

RSpec.describe Approval::Comment, type: :model do
  describe "association" do
    it { is_expected.to belong_to(:request).class_name("Approval::Request").inverse_of(:comments) }
    it { is_expected.to belong_to(:user).class_name("User") }
  end

  describe "validation" do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_length_of(:content).is_at_most(Approval.config.comment_maximum) }
  end

  describe "factory" do
    let(:request) { create(:request, :pending, :with_comments, :with_items) }
    subject { build(:comment, request: request) }
    it { is_expected.to be_valid }
  end
end
