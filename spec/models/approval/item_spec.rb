require "spec_helper"

RSpec.describe Approval::Item, type: :model do
  describe "Association" do
    it { is_expected.to belong_to(:request).class_name("Approval::Request").inverse_of(:items) }
    it { is_expected.to belong_to(:resource) }
  end

  describe "Association" do
    it { is_expected.to validate_presence_of(:resource_type) }
    it { is_expected.to validate_presence_of(:event) }
    it { is_expected.to validate_inclusion_of(:event).in_array(described_class::EVENTS) }

    context "when event is create" do
      subject { build :item, :create }
      it { is_expected.not_to validate_presence_of(:resource_id) }
      it { is_expected.not_to validate_presence_of(:params) }
    end

    context "when event is update" do
      subject { build :item, :update }
      it { is_expected.to validate_presence_of(:resource_id) }
      it { is_expected.to validate_presence_of(:params) }
    end

    context "when event is destroy" do
      subject { build :item, :destroy }
      it { is_expected.to validate_presence_of(:resource_id) }
      it { is_expected.not_to validate_presence_of(:params) }
    end

    context "when event is perform" do
      subject { build :item, :perform }
      it { is_expected.not_to validate_presence_of(:resource_id) }
      it { is_expected.not_to validate_presence_of(:params) }
    end
  end

  describe "#create_event?" do
    subject { item.create_event? }

    context "when event is create" do
      let(:item) { build :item, :create }
      it { is_expected.to eq true }
    end

    context "when event is update" do
      let(:item) { build :item, :update }
      it { is_expected.to eq false }
    end

    context "when event is destroy" do
      let(:item) { build :item, :destroy }
      it { is_expected.to eq false }
    end

    context "when event is perform" do
      let(:item) { build :item, :perform }
      it { is_expected.to eq false }
    end
  end

  describe "#update_event?" do
    subject { item.update_event? }

    context "when event is create" do
      let(:item) { build :item, :create }
      it { is_expected.to eq false }
    end

    context "when event is update" do
      let(:item) { build :item, :update }
      it { is_expected.to eq true }
    end

    context "when event is destroy" do
      let(:item) { build :item, :destroy }
      it { is_expected.to eq false }
    end

    context "when event is perform" do
      let(:item) { build :item, :perform }
      it { is_expected.to eq false }
    end
  end

  describe "#destroy_event?" do
    subject { item.destroy_event? }

    context "when event is create" do
      let(:item) { build :item, :create }
      it { is_expected.to eq false }
    end

    context "when event is update" do
      let(:item) { build :item, :update }
      it { is_expected.to eq false }
    end

    context "when event is destroy" do
      let(:item) { build :item, :destroy }
      it { is_expected.to eq true }
    end

    context "when event is perform" do
      let(:item) { build :item, :perform }
      it { is_expected.to eq false }
    end
  end

  describe "#perform_event?" do
    subject { item.perform_event? }

    context "when event is create" do
      let(:item) { build :item, :create }
      it { is_expected.to eq false }
    end

    context "when event is update" do
      let(:item) { build :item, :update }
      it { is_expected.to eq false }
    end

    context "when event is destroy" do
      let(:item) { build :item, :destroy }
      it { is_expected.to eq false }
    end

    context "when event is perform" do
      let(:item) { build :item, :perform }
      it { is_expected.to eq true }
    end
  end

  describe "#apply" do
    let(:request) { build :request, :pending }
    let(:comment) { build :comment, request: request, user: request.request_user }
    let(:item) { build :item, event, request: request }

    before do
      request.comments << comment
      request.items << item
      request.save!
    end

    subject { item.apply }

    context "when event is create" do
      let(:event) { :create }

      it "creates book" do
        expect { subject }.to change { Book.count }.by(1)
      end
    end

    context "when event is update" do
      let(:event) { :update }

      it "updates book" do
        expect { subject }.to change { Book.first.updated_at }
      end
    end

    context "when event is destroy" do
      let(:event) { :destroy }

      it "destroys book" do
        expect { subject }.to change { Book.count }.by(-1)
      end
    end

    context "when event is perform" do
      let(:event) { :perform }

      it "performs from Book" do
        expect(Book).to receive(:perform).once
        subject
      end
    end
  end
end
