# == Schema Information
#
# Table name: retrospectives
#
#  id         :bigint           not null, primary key
#  status     :enum             default("open"), not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_retrospectives_on_title  (title) UNIQUE
#
require "rails_helper"

RSpec.describe Retrospective do
  subject(:retrospective) { build_stubbed(:retrospective) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:status) }

    # Use `create` rather than `build_stubbed` to verify uniqueness
    # because it needs the model to be saved in the database.
    context "when validating uniqueness of title" do
      subject(:existing_retrospective) { create(:retrospective) }

      it { is_expected.to validate_uniqueness_of(:title) }
    end

    context "when validating only one open retrospective" do
      it "allows creating a new open retrospective if there are no existing open retrospectives" do
        expect(retrospective).to be_valid
      end

      it "does not allow creating a new open retrospective if there is already an open retrospective" do
        # Use `create` rather than `build_stubbed` because the first retro needs to be saved to the db
        # for the validation to check if there already is an open one.
        create(:retrospective, status: described_class.statuses[:open])
        retro2 = described_class.new(title: "foo", status: described_class.statuses[:open])
        retro2.valid?
        expect(retro2.errors[:status]).to include("There can only be one open retrospective at a time.")
      end
    end
  end

  describe "enum" do
    it {
      expect(retrospective).to define_enum_for(:status)
        .with_values(open: "open", closed: "closed")
        .backed_by_column_of_type(:enum)
    }
  end

  describe "factory" do
    it { is_expected.to be_valid }
  end
end
