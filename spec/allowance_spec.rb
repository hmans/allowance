require 'spec_helper'

module Allowance
  describe "#define" do
    it "should return an instance of Allowance::Permissions" do
      Allowance.define.should be_kind_of(Allowance::Permissions)
    end

    it "should make sure the passed block is executed" do
      p = Allowance.define do |allow|
        allow.allow :sing
      end

      insist p.allowed? :sing
    end
  end
end
