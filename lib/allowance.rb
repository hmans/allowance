require 'allowance/version'
require 'allowance/permissions'

module Allowance
  def self.define(&blk)
    Permissions.new(&blk)
  end
end
