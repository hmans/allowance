require 'spec_helper'

class User
  include Allowance::Subject

  attr_reader :role

  def initialize(role = :standard)
    @role = role
  end

  def define_permissions
    allow :view

    if role == :admin
      allow :manage
    end
  end
end

module Allowance
  describe "a class with the Allowance::Subject mixin" do
    it do
      @user = User.new(:admin)
      expect(@user.allowed?(:manage)).to be_true
    end
  end
end
