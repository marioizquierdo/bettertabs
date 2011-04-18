class BettertabsController < ApplicationController
  
  def static
  end
  
  def link_tab_1
  end
  
  def link_tab_2
  end
  
  def ajax
    respond_to do |format|
      format.html {}
      format.js { render 'ajax' }
    end
  end
  
  def mixed
    respond_to do |format|
      format.html {}
      format.js { render 'mixed' }
    end
  end
  
  def mixed_with_erb
    respond_to do |format|
      format.html {}
      format.js { render 'tab_content' if params[:erb_test_selected_tab] == 'ajax_tab' }
    end
  end
  
end
