require 'spec_helper'

module Allowance
  describe Permissions do
    SomeClass = Class.new
    SomeOtherClass = Class.new

    it "should allow permissions to be specified and queried through its instance methods" do
      subject.can! :sing
      subject.allow! :dance

      insist subject.can? :dance
      insist subject.allowed? :sing
    end

    it "should allow simple permissions to be specified" do
      subject.moo!

      insist subject.moo?
      refuse subject.quack?
    end

    it "should support a block-style initialization" do
      p = Permissions.new do |can|
        can.sing!
      end

      insist p.allowed? :sing
      insist p.sing?
    end

    it "should not modify the block's scope" do
      yup = true
      nope = false

      p = Permissions.new do |can|
        can.sing!  if yup
        can.dance! if nope
      end

      insist p.sing?
      refuse p.dance?
    end

    it "should allow verbs and objects" do
      subject.update! SomeClass

      insist subject.update? SomeClass
      refuse subject.destroy? SomeClass
      refuse subject.update? SomeOtherClass
    end

    it "should expand :read to include :index and :show" do
      subject.read! SomeClass

      insist subject.read? SomeClass
      insist subject.index? SomeClass
      insist subject.show? SomeClass
    end

    it "should verify permissions against model instances" do
      model_class = Class.new
      model_class.stub(model_name: 'Model')
      model_class.should_receive(:some_scope).and_return(model_class)

      model_instance = model_class.new
      model_instance.stub!(:id => 123)

      count_double = double("count")
      count_double.should_receive(:count).and_return(1)
      model_class.should_receive(:where).
        with(id: 123).
        and_return(count_double)

      subject.read! model_class, lambda { |r| r.some_scope }

      insist subject.read? model_instance
    end

    describe "#scoped_model" do
      it "should allow scopes to be defined through lambdas" do
        model = mock
        model.should_receive(:some_scope).and_return(scoped_model = mock)

        subject.view! model, lambda { |r| r.some_scope }
        subject.scoped_model(:view, model).should == scoped_model
      end

      it "should allow scopes to be defined through a conditions hash" do
        model = mock
        model.should_receive(:where).with(:awesome => true).and_return(scoped_model = mock)

        subject.view! model, :awesome => true

        subject.scoped_model(:view, model).should == scoped_model
      end

      it "should allow scopes to be defined through a conditions string" do
        model = mock
        model.should_receive(:where).with("awesome = true").and_return(scoped_model = mock)

        subject.view! model, "awesome = true"

        subject.scoped_model(:view, model).should == scoped_model
      end

      it "should allow scopes to be defined through a conditions array" do
        model = mock
        model.should_receive(:where).with(["awesome = ?", true]).and_return(scoped_model = mock)

        subject.view! model, ["awesome = ?", true]

        subject.scoped_model(:view, model).should == scoped_model
      end
    end
  end
end
