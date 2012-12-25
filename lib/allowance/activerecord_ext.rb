module Allowance
  module ActiveRecordExtensions
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def accessible_by(subject, verb = nil)
        subject.allowed_scope(self, verb)
      end
    end
  end
end

ActiveRecord::Base.send(:include, Allowance::ActiveRecordExtensions)
