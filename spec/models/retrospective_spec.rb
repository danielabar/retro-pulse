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

  describe "scopes" do
    describe ".open_retrospective" do
      it "returns AR relation of a single open retro" do
        create(:retrospective, status: described_class.statuses[:open])
        open_retro = described_class.open_retrospective.first
        expect(open_retro).to be_a(described_class)
        expect(open_retro.status).to eq("open")
      end

      it "returns an empty AR relation if no open retrospectives exist" do
        open_retro = described_class.open_retrospective.first
        expect(open_retro).to be_nil
      end
    end
  end

  describe "#comments_by_category" do
    it "returns comments for the given category" do
      retro = create(:retrospective)
      comment1 = create(:comment, retrospective: retro, category: Comment.categories[:keep])
      comment2 = create(:comment, retrospective: retro, category: Comment.categories[:keep])
      comment3 = create(:comment, retrospective: retro, category: Comment.categories[:stop])

      comments = retro.comments_by_category(category: Comment.categories[:keep])
      expect(comments.size).to eq(2)
      expect(comments).to include(comment1, comment2)
      expect(comments).not_to include(comment3)
    end

    it "returns empty collection if no comments with given category exist" do
      retro = create(:retrospective)
      create(:comment, retrospective: retro, category: Comment.categories[:keep])

      comments = retro.comments_by_category(category: Comment.categories[:try])
      expect(comments.size).to eq(0)
    end
  end
end
