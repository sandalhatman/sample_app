require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_selector('h1',    text: 'Sample App') }
    it { should have_selector('title', text: full_title('')) }
    it { should_not have_selector 'title', text: '| Home' }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        @post1 = FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        @post2 = FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        valid_signin user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      #
      # Exercise 10.5.1
      #
      # Test to see if pluralization works
      #
      describe "showing the correct number of microposts" do

        #Start with 2 microposts (via factory girl)
        describe "with multiple microposts" do
          before { visit root_path }
          it { Micropost.count.should > 1 }       #Insure multiple microposts
          it { should have_selector("span", text: "microposts") }
        end

        describe "with a single micropost" do
          before do
            delete micropost_path(@post1)
            visit root_path
          end
          it { Micropost.count.should == 1 }       #Insure single micropost
          it { should have_selector("span", text: "micropost") }
          it { should_not have_selector("span", text: "microposts") }
        end

        describe "with zero microposts" do
          before do
            delete micropost_path(@post1)
            delete micropost_path(@post2)
            visit root_path
          end
          it { Micropost.count.should == 0 }       #Insure zero micropost
          it { should have_selector("span", text: "microposts") }
        end

      end

    end
  end

  describe "Help page" do
    before { visit help_path }

    it { should have_selector('h1',    text: 'Help') }
    it { should have_selector('title', text: full_title('Help')) }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_selector('h1',    text: 'About') }
    it { should have_selector('title', text: full_title('About Us')) }
  end

  describe "Contact page" do
    before { visit contact_path }

    it { should have_selector('h1',    text: 'Contact') }
    it { should have_selector('title', text: full_title('Contact')) }
  end
end

