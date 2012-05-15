require_dependency 'boards_controller'

class BoardsController < ApplicationController
  def show_with_sp
    #logger.info("Sticky priority is here")
    respond_to do |format|
      format.html {
        sort_init 'updated_on', 'desc'
        sort_update	'created_on' => "#{Message.table_name}.created_on",
                    'replies' => "#{Message.table_name}.replies_count",
                    'updated_on' => "#{Message.table_name}.updated_on"

        @topic_count = @board.topics.count
        @topic_pages = ActionController::Base::Paginator.new self, @topic_count, per_page_option, params['page']
        # change in sort order
        order_sort = ["#{Message.table_name}.sticky_priority DESC", sort_clause].compact.join(', ')
        #logger.info(order_sort)
        @topics =  @board.topics.find :all, :order => order_sort,
                                      :include => [:author, {:last_reply => :author}],
                                      :limit  =>  @topic_pages.items_per_page,
                                      :offset =>  @topic_pages.current.offset
        @message = Message.new
        render :action => 'show', :layout => !request.xhr?
      }
      format.atom {
        @messages = @board.messages.find :all, :order => 'created_on DESC',
                                               :include => [:author, :board],
                                               :limit => Setting.feeds_limit.to_i
        render_feed(@messages, :title => "#{@project}: #{@board}")
      }
    end
  end

  alias_method_chain :show, :sp
end
