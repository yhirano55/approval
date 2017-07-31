require "spec_helper"

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:approval_requests).class_name("Approval::Request").with_foreign_key(:request_user_id) }
  it { is_expected.to have_many(:approval_comments).class_name("Approval::Comment").with_foreign_key(:user_id) }

  describe "RequestForm" do
    let(:user) { build :user }
    let(:records) { build_list :book, 3 }
    let(:reason) { "reason" }

    describe "#request_for_create" do
      subject { user.request_for_create(records, reason: reason) }
      it { is_expected.to be_a(Approval::RequestForm::Create) }
    end

    describe "#request_for_update" do
      subject { user.request_for_update(records, reason: reason) }
      it { is_expected.to be_a(Approval::RequestForm::Update) }
    end

    describe "#request_for_destroy" do
      subject { user.request_for_destroy(records, reason: reason) }
      it { is_expected.to be_a(Approval::RequestForm::Destroy) }
    end
  end

  describe "RespondForm" do
    let(:user) { build :user }
    let(:request) { build :request }
    let(:reason) { "reason" }

    describe "#cancel_request" do
      subject { user.cancel_request(request, reason: reason) }
      it { is_expected.to be_a(Approval::RespondForm::Cancel) }
    end

    describe "#approve_request" do
      subject { user.approve_request(request, reason: reason) }
      it { is_expected.to be_a(Approval::RespondForm::Approve) }
    end

    describe "#reject_request" do
      subject { user.reject_request(request, reason: reason) }
      it { is_expected.to be_a(Approval::RespondForm::Reject) }
    end
  end
end
