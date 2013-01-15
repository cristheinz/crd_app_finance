require 'spec_helper'

describe Expense do
  let(:user) { FactoryGirl.create(:user) }
  let(:label) { FactoryGirl.create(:label) }
  let(:expense) { user.expenses.build(label_id: label.id) }

  subject { expense }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Expense.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "user methods" do    
    it { should respond_to(:user) }
    it { should respond_to(:label) }
    its(:user) { should == user }
    its(:label) { should == label }
  end

  describe "when label id is not present" do
    before { expense.label = nil }
    it { should_not be_valid }
  end

  describe "when user id is not present" do
    before { expense.user_id = nil }
    it { should_not be_valid }
  end
end
