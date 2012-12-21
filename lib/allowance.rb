require 'allowance/version'
require 'allowance/permissions'

if defined?(ActiveRecord)
  require 'allowance/activerecord_ext'
end

module Allowance
  def self.define(&blk)
    Permissions.new(&blk)
  end
end
