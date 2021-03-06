# coding: UTF-8
require_relative '../../spec_helper'
require_relative '../../../app/models/visualization/member'

describe Carto::Visualization do

  before(:all) do
    @user = create_user({
        email: 'admin@cartotest.com', 
        username: 'admin', 
        password: '123456'
      })
  end

  before(:each) do
    CartoDB::Visualization::Member.any_instance.stubs(:has_named_map?).returns(false)
    delete_user_data(@user)
  end

  after(:all) do
    @user.destroy
  end

  describe '#tags=' do
    it 'should not set blank tags' do
      vis = Carto::Visualization.new
      vis.tags = ["tag1", " ", ""]

      vis.tags.should eq ["tag1"]
    end
  end

  describe 'children' do
    it 'should correctly count children' do
      map = ::Map.create(user_id: @user.id)

      parent = CartoDB::Visualization::Member.new({
          user_id: @user.id,
          name:    "visualization #{rand(9999)}",
          map_id:  map.id,
          type:    CartoDB::Visualization::Member::TYPE_DERIVED,
          privacy: CartoDB::Visualization::Member::PRIVACY_PUBLIC
        }).store

      child = CartoDB::Visualization::Member.new({
          user_id:   @user.id,
          name:      "visualization #{rand(9999)}",
          map_id:    ::Map.create(user_id: @user.id).id,
          type:      Visualization::Member::TYPE_SLIDE,
          privacy:   CartoDB::Visualization::Member::PRIVACY_PUBLIC,
          parent_id: parent.id 
        }).store

      parent = Carto::Visualization.where(id: parent.id).first
      parent.children.count.should == 1

      child2 = CartoDB::Visualization::Member.new({
          user_id:   @user.id,
          name:      "visualization #{rand(9999)}",
          map_id:    ::Map.create(user_id: @user.id).id,
          type:      Visualization::Member::TYPE_SLIDE,
          privacy:   CartoDB::Visualization::Member::PRIVACY_PUBLIC,
          parent_id: parent.id
        }).store
      child.set_next_list_item!(child2)

      child = Carto::Visualization.where(id: child.id).first
      child2 = Carto::Visualization.where(id: child2.id).first
      parent = Carto::Visualization.where(id: parent.id).first

      parent.children.count.should == 2

    end
  end

end
