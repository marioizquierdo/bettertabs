class BettertabsController < ApplicationController

  def static
  end

  def link_tab_1
  end

  def link_tab_2
  end

  def ajax
    render partial: 'ajax' and return if request.xhr?
  end

  def only_content_block
  end

  def mixed
    render partial: 'mixed' and return if request.xhr?
  end

  def mixed_with_erb
    render partial: 'tab_content' and return if request.xhr? and params[:erb_test_selected_tab] == 'ajax_tab'
  end

end
