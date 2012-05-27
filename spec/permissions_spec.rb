require 'spec_helper'

module Allowance
  describe Permissions do
    SomeClass = Class.new
    SomeOtherClass = Class.new

    it "should allow simple permissions to be specified" do
      p = Permissions.new do
        can :moo
      end

      insist p.can?(:moo)
      refuse p.can?(:quack)
    end

    it "should allow verbs and objects" do
      p = Permissions.new do
        can :update, SomeClass
      end

      insist p.can?(:update, SomeClass)
      refuse p.can?(:destroy, SomeClass)
      refuse p.can?(:update, SomeOtherClass)
    end
  end
end
