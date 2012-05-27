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

    it "should run the permission definition block against the provided context" do
      skills = mock(:singing => :good)

      p = Permissions.new(skills) do |skills|
        can :sing if skills.singing == :good
      end

      insist p.can? :sing
    end

    it "should expand :view to include :index and :show" do
      p = Permissions.new do
        can :view, SomeClass
      end

      insist p.can?(:view, SomeClass)
      insist p.can?(:index, SomeClass)
      insist p.can?(:show, SomeClass)
    end

    it "should verify permissions against model instances" do
      model_class = Class.new
      model_class.should_receive(:some_scope).and_return(model_class)

      model_instance = model_class.new
      model_instance.stub!(:id => 123)

      model_class.should_receive(:find).and_return(model_instance)

      p = Permissions.new do
        can :view, model_class, lambda { some_scope }
      end

      insist p.can?(:view, model_instance)
    end

    describe "#scoped_model" do
      it "should allow scopes to be defined through lambdas" do
        model = mock
        model.should_receive(:some_scope).and_return(scoped_model = mock)

        p = Permissions.new do
          can :view, model, lambda { some_scope }
        end

        p.scoped_model(:view, model).should == scoped_model
      end

      it "should allow scopes to be defined through where conditions" do
        model = mock
        model.should_receive(:where).with(:awesome => true).and_return(scoped_model = mock)

        p = Permissions.new do
          can :view, model, :awesome => true
        end

        p.scoped_model(:view, model).should == scoped_model
      end
    end
  end
end
