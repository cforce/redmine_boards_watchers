require 'redmine'
require_dependency 'messages_controller'

class MessagesController < ApplicationController
  # Create a new topic
  def new_with_watchers
# Lines added by boards watchers plugin - start
		unless params[:message].nil?
	    return new_without_watchers if params[:message]['watcher_user_ids'].blank? && params[:message]['sticky_priority'].blank?
		end
# Lines added by boards watchers plugin - end

    @message = Message.new(params[:message])
    @message.author = User.current
    @message.board = @board
	  
# Lines added by boards watchers plugin - start
	  if params[:message] && !params[:message]['watcher_user_ids'].blank?
	    @message.watcher_user_ids = params[:message]['watcher_user_ids'] if User.current.allowed_to?({:controller => "boards_watchers", :action => "manage_topic"}, @project) 
		end
# Lines added by boards watchers plugin - end

    if params[:message] && User.current.allowed_to?(:edit_messages, @project)
      @message.locked = params[:message]['locked']
# Lines added by boards watchers plugin - start
      sp=params[:message]['sticky_priority'].to_i
      @message.sticky = (sp > 0 ? '1' : '0')
      @message.sticky_priority = sp
# Lines added by boards watchers plugin - end
    end
    if request.post? && @message.save
      call_hook(:controller_messages_new_after_save, { :params => params, :message => @message})
      attachments = Attachment.attach_files(@message, params[:attachments])
      render_attachment_warning_if_needed(@message)
      redirect_to :action => 'show', :id => @message
    end
  end

  def edit_with_watchers
    if params[:message] && @message.editable_by?(User.current)
      sp=params[:message]['sticky_priority'].to_i
      @message.sticky = (sp > 0 ? '1' : '0')
      @message.sticky_priority = sp
      params[:message]['sticky']='1' if @message.sticky?
    end
    edit_without_watchers
  end

  def reply_with_watchers
    if @topic && params[:bw_watcher_ids]
      watcher_ids=params[:bw_watcher_ids]

      @project.users.sort.each do |user|
        @topic.set_watcher(user,false)
      end

      watcher_ids.each do |w|
        watcher=Watcher.new({ 'user_id' => w })
        watcher.watchable=@topic
        watcher.save
      end if watcher_ids
    end
    reply_without_watchers
  end

	alias_method_chain :new, :watchers
  alias_method_chain :edit, :watchers
  alias_method_chain :reply, :watchers
end
