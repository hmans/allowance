module Allowance
  module ActiveRecordExtensions
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def accessible_by(subject, verb = :index)
        subject.allowed_scope(verb, self)
      end
    end
  end
end

ActiveRecord::Base.send(:include, Allowance::ActiveRecordExtensions)
