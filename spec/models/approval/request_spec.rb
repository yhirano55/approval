require "spec_helper"

RSpec.describe Approval::Request, type: :model do
  describe "Association" do
    it { is_expected.to belong_to(:request_user).class_name("User") }
    it { is_expected.to belong_to(:respond_user).class_name("User") }
    it { is_expected.to have_many(:comments).class_name("::Approval::Comment").dependent(:destroy) }
    it { is_expected.to have_many(:items).class_name("::Approval::Item").dependent(:destroy) }
  end

  it { is_expected.to define_enum_for(:state).with(described_class.states) }

  describe "Validation" do
    it { is_expected.to validate_presence_of(:state) }
    it { is_expected.to validate_presence_of(:comments) }
    it { is_expected.to validate_presence_of(:items) }

    context "when request not pending" do
      subject { build :request, :cancelled }
      it { is_expected.to validate_presence_of(:respond_user) }
    end
  end

  describe "Callback" do
    context "before create" do
      let(:request) { build :request, :pending }
      let(:comment) { build :comment, request: request, user: request.request_user }
      let(:item) { build :item, :create, request: request }

      it "set requested_at" do
        expect(request.requested_at).to be_nil
        request.comments << comment
        request.items << item
        request.save!
        expect(request.requested_at).to be_present
      end
    end
  end
end
