require 'redmine'
require 'boards_watchers_patches'
require 'dispatcher'

unless Redmine::Plugin.registered_plugins.keys.include?(:redmine_boards_watchers)
	Redmine::Plugin.register :redmine_boards_watchers do
	  name 'Boards watchers management and sticky priority levels add-on'
	  author 'Vitaly Klimov'
	  author_url 'mailto:vitaly.klimov@snowbirdgames.com'
	  description 'Plugin creates three levels of sticky messages and allows managing of forums/topics watchers'
	  version '0.1.3'

		project_module :boards do
			permission :delete_board_watchers, {:boards_watchers => [:manage] }, :require => :member
			permission :delete_message_watchers, {:boards_watchers => [:manage_topic, :manage_topic_remote] }, :require => :member
		end
  end

  class BoardsWatchersHook  < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context = {})
      stylesheet_link_tag('boards_watchers', :plugin => 'redmine_boards_watchers')
    end
  end
end

Dispatcher.to_prepare :redmine_boards_watchers do
  require 'message'

  unless Message.included_modules.include? BoardsWatchers::Patches::StickyPriorityMessagePatch
    Message.send(:include, BoardsWatchers::Patches::StickyPriorityMessagePatch)
  end
end


