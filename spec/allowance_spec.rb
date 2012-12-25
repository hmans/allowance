require 'spec_helper'

describe "a class with the Allowance mixin" do
  let(:some_class) { Class.new }
  let(:some_other_class) { Class.new }

  subject do
    Class.new do
      include Allowance
    end.new
  end

  it "has an #allow method that allows setting of permissions" do
    subject.allow :read
    insist subject.allowed? :read
    refuse subject.allowed? :manage
  end

  it "automatically runs the #define_permissions method" do
    subject.class.class_eval do
      def define_permissions
        allow :manage
      end
    end

    insist subject.allowed? :manage
  end

  it "supports verbs and objects" do
    subject.allow :update, some_class

    insist subject.allowed? :update,  some_class
    refuse subject.allowed? :destroy, some_class
    refuse subject.allowed? :update,  some_other_class
  end

  describe 'verb expansion' do
    it "expands :read to include :index and :show" do
      subject.allow :read, some_class

      insist subject.allowed? :read, some_class
      insist subject.allowed? :index, some_class
      insist subject.allowed? :show, some_class
    end
  end

  it "should verify permissions against model instances" do
    model_class = Class.new
    model_class.stub(model_name: 'Model')
    model_class.should_receive(:some_scope).and_return(model_class)

    model_instance = model_class.new
    model_instance.stub!(:id => 123)

    model_class.should_receive(:exists?).with(model_instance).and_return(true)

    subject.allow :read, model_class, lambda { |r| r.some_scope }

    insist subject.allowed? :read, model_instance
  end

  describe "#allowed_scope" do
    let(:model) { double }
    let(:allowed_scope) { double }

    it "allows scopes to be defined through lambdas" do
      subject.allow :read, model, ->(m) { m.some_scope }
      model.should_receive(:some_scope).and_return(allowed_scope)
      subject.allowed_scope(model, :read).should == allowed_scope
    end

    it "allows scopes to be defined through a conditions hash" do
      subject.allow :read, model, :awesome => true
      model.should_receive(:where).with(:awesome => true).and_return(allowed_scope)
      subject.allowed_scope(model, :read).should == allowed_scope
    end

    it "allows scopes to be defined through a conditions string" do
      subject.allow :read, model, "awesome = true"
      model.should_receive(:where).with("awesome = true").and_return(allowed_scope)
      subject.allowed_scope(model, :read).should == allowed_scope
    end

    it "allow scopes to be defined through a conditions array" do
      subject.allow :read, model, ["awesome = ?", true]
      model.should_receive(:where).with(["awesome = ?", true]).and_return(allowed_scope)
      subject.allowed_scope(model, :read).should == allowed_scope
    end

    it "prevents access to models that have on permissions defined" do
      model.should_receive(:where).with("1=0").and_return(allowed_scope)
      subject.allowed_scope(model, :read).should == allowed_scope
    end
  end

end
