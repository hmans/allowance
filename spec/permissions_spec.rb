require 'spec_helper'

module Allowance
  describe Permissions do
    it "should do something cool" do
      p = Permissions.new do
        can :moo
      end

      p.can?(:moo).should == true
    end
  end
end
