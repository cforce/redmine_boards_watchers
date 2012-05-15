
module BoardsWatchers
  module Patches
    module StickyPriorityMessagePatch
      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable

          attr_protected :sticky_priority
          #alias_method_chain :issues, :parent_sort
          #alias_method_chain :issue_ids, :parent_sort if Query.method_defined?(:issue_ids)
        end
      end

      module InstanceMethods
        def sticky_priority=(arg)
          if sticky?
            new_priority=arg.to_i
            new_priority=1 if new_priority == 0
            write_attribute :sticky_priority, new_priority
          else
            write_attribute :sticky_priority, 0
          end
        end

        def sticky_priority
          sp=read_attribute(:sticky_priority) || 0
          sp=1 if sp==0 && sticky?
          sp
        end
      end
    end

  end
end
