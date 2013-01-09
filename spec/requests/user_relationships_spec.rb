require 'spec_helper'

#
#
#
#  Exercise 11.5.1
#  Modified from: http://stackoverflow.com/questions/10254115/add-tests-for-dependent-destroy-in-the-relationship-model-chapter-11-exercise
#
#
#

describe "User Relationships" do

  # FOLLOWER keeps track of FOLLOWED
  # If FOLLOWED is deleted FOLLOWER should delete its relations to FOLLOWED

  let(:follower) { FactoryGirl.create(:admin) }
  let(:followed) { FactoryGirl.create(:user) }
  let(:extraperson) { FactoryGirl.create(:user) }

  #subject { page }

  before do
    # Sign admin in so he can delete other user
    valid_signin(follower)

    # Have both users follow eachother
    follower.follow!(followed)
    followed.follow!(follower)

    # After a person is deleted, make sure other people
    # still show up in their relationship list  (un-necessary test)
    follower.follow!(extraperson)

    # If a followed person is deleted, make sure that the follower
    # is no longer related to that person (un-necessary test)
    extraperson.follow!(followed)

    # Tests are un-necessary because all users share the same relationships table

    # Observation. It seems disabling dependent: destroy for the primary relation
    # kills both tests. So this relation affects both. But, disabling dependency for the
    # reverse relation only interferes with the reverse test.
  end

  it "follower should lose relationships with destroyed followed" do
    @relationships = followed.relationships
    followed.destroy
    @relationships.should be_empty


    # Originally made a relation with three users. After deleting a user,
    # make sure the remaining relationship still exists. Have to refresh variables
    # because although the database updated the variables didn't. Only have to refresh
    # follower, extraperson never had any relationships
    followerRefresh = User.find_by_id(follower.id)


    refreshRelationships = followerRefresh.relationships
    refreshRelationships.each do |relation|
      # This works because followed gets removed from database but variable
      # doesn't update
      relation.followed_id.should_not == followed.id        # Dead relationship

      # Use refreshed variable in this case
      relation.followed_id.should == extraperson.id         # Live relationship
    end

  end

  it "follower should lose reverse_relationships with destroyed followed" do
    @relationships = followed.reverse_relationships
    followed.destroy
    @relationships.should be_empty

    # 'extraperson' followed 'followed'. Make sure it is no longer following.
    # First refresh extra person
    extraRefresh = User.find_by_id(extraperson.id)

    # 'extraperson' only followed 'followed' and no one else, so just check if
    # relationship array is empty
    refreshRelationships = extraRefresh.relationships
    refreshRelationships.should be_empty

    refreshRelationships.each do |relation|
      puts relation.inspect
    end


  end
end




