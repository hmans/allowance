SPEC_DIR = File.dirname(__FILE__)
lib_path = File.expand_path("#{SPEC_DIR}/../lib")
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)

require 'allowance'

def insist(what)
  what.should == true
end

def refuse(what)
  what.should == false
end

# class User
#   include Allowance

#   attr_accessor :role

#   def initialize(role = :standard)
#     @role = role
#   end

#   def define_permissions
#     allow :view

#     if role == :admin
#       allow :manage
#     end
#   end
# end
