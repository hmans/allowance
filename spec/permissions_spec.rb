require 'spec_helper'

module Allowance
  describe Permissions do
    it "should allow simple permissions to be specified" do
      p = Permissions.new do
        can :moo
      end

      p.can?(:moo).should == true
      p.can?(:quack).should == false
    end
  end
end
