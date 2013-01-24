require 'spec_helper'

describe Track do
  let(:user) { FactoryGirl.create(:user) }
  let(:label) { FactoryGirl.create(:label) }
  let(:expense) { user.expenses.create(label_id: label.id) }

  before { @track = expense.tracks.build(date: 1.hour.ago,
  						 value: 30,status:"P") }

  subject { @track }

  it { should respond_to(:expense_id) }
  it { should respond_to(:date) }
  it { should respond_to(:value) }
  it { should respond_to(:status) }
  it { should respond_to(:label) }
  it { should respond_to(:user) }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to expense_id" do
      expect do
        Track.new(expense_id: expense.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "when expense_id is not present" do
    before { @track.expense_id = nil }
    it { should_not be_valid }
  end

  describe "when date is not present" do
    before { @track.date = nil }
    it { should_not be_valid }
  end

  describe "when status is not present" do
    before { @track.status = nil }
    it { should_not be_valid }
  end

  describe "when value is not present" do
    before { @track.value = nil }
    it { should_not be_valid }
  end

  describe "when value format is invalid" do
  	before { @track.value = "aaa" }
  	it { should_not be_valid }
  end
  describe "when value format is valid" do
  	before { @track.value = 10.33 }
  	it { should be_valid }
  end
  describe "when value is zero" do
  	before { @track.value = 0 }
  	it { should_not be_valid }
  end
end
