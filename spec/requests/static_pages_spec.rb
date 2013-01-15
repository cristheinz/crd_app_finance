require 'spec_helper'

describe "StaticPages" do

  subject { page }

  describe "Home page" do
  	before { visit root_path }

  	it { should have_selector('title', text: 'Finance App') }
    it { should have_link('finance app', href: root_path) }
    it { should have_link('Sign in', href: signin_path) }
    it { should have_link('Sign up now!', href: signup_path) }
  end
end
