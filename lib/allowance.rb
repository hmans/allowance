module Allowance
end

require 'allowance/version'
require 'allowance/subject'

if defined?(ActiveRecord)
  require 'allowance/activerecord_ext'
end
