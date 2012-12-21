require 'allowance/version'
require 'allowance/permissions'
require 'allowance/activerecord_ext'

module Allowance
  def self.define(&blk)
    Permissions.new(&blk)
  end
end
