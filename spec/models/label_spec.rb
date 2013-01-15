require 'spec_helper'

describe Label do
  before do
    @label = Label.new(name: "Example label")
  end

  subject { @label }

  it { should respond_to(:name) }
  it { should respond_to(:expenses) }
  it { should respond_to(:users) }

  it { should be_valid }

  describe "when name is not present" do
    before { @label.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @label.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when name is already taken" do
    before do
      label_with_same_name = @label.dup
      label_with_same_name.name = @label.name.upcase
      label_with_same_name.save
    end

    it { should_not be_valid }
  end
end
