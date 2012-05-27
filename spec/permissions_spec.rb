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

    it "should run the permission definition block against the provided context"

    it "should expand :view to include :index and :show" do
      p = Permissions.new do
        can :view, SomeClass
      end

      insist p.can?(:view, SomeClass)
      insist p.can?(:index, SomeClass)
      insist p.can?(:show, SomeClass)
    end

    describe "#scoped_model" do
      it "should return a properly scoped model" do
        model = mock
        model.should_receive(:some_scope).and_return(scoped_model = mock)

        p = Permissions.new do
          can :view, model, -> { some_scope }
        end

        p.scoped_model(:view, model).should == scoped_model
      end
    end
  end
end
