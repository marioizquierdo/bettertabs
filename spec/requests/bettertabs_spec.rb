# Some bettertabs specifications:
#
#  * Should always work with javascript disabled (using the urls of the tabs links)
#  * The bettertabs hepler should accept:
#    * args: (bettertabs_id, options)
#    * options can be:
#       * :selected_tab => tab_id to select by default
#         * :selected_tab should be overridden with params[:"#{bettertabs_id}_selected_tab"] if present
#       * any other option is used as wrapper html_options (wrapper is the top-level widget dom element).
#  * The bettertabs helper should render clear markup:
#     * A wrapper with class 'bettertabs'
#     * Tabs markup
#        * ul.tabs > li > a  
#        * selected tab is ul.tabs > li.active > a
#        * each a element has element attributes:
#           * data-tab-type (for javascript: change click behavior depending on type "static", "link" or "ajax")
#           * data-show-content-id (for javascript: element id to show when select this tab)
#     * sections for each tab content.
#     * use a unique html id (based on bettertabs_id and tab_id) for each Tab and Content
#  * The bettertabs builder ".from" method should accept:
#     * args: (tab_id, tab_name, options, &block)
#     * args: (tab_id, options, &block)
#    * If block_given? the block is used as content related to this tab
#     * options can be:
#       * :partial => to use as content. Defaults to tab_id
#          * if block_given? this option can not be used (if used, raise an error)
#       * :url => for the tab link, that should go to this selected tab when javascript is disabled. Defaults to { :"#{bettertabs_id}_selected_tab" => tab_id }
#       * :tab_type => used in the markup as the link data-tab-type value. Can be :static, :link or :ajax (or the corresponding strings). Raise error otherwise. Defaults to :static.
#  * The bettertabs builder ".static", ".link" and ".ajax" methods are only a convenient way to use ".for" method with :tab_type set to :static, :link or :ajax respectively.
#  * Content is rendered only for active tab, except when tab_type is :static, where content is always rendered (ready to show when select that tab using javascript).
#  * When ajax call (format.js), the bettertabs helper should return ONLY the content of the selected tab (to simplify the controller render partial calls.).
#

require 'spec_helper'

describe "Bettertabs requests" do
  describe "GET /bettertabs/static" do
    before(:all) { get '/bettertabs/static' } 
    
    it "has a 200 status code" do
      response.status.should be(200)
    end
    
    it "should render all content even for hidden tabs" do
      response.body.should include("Content for static_tab_1")
      response.body.should include("Content for static_tab_2")
      response.body.should include("tab_content partial content")
    end
    
    it "should not include the attribute data-ajax-url in static tabs" do
      response.body.should_not include("data-ajax-url")
    end
  end
  
  describe "GET /bettertabs/link_tab_1" do
    before(:all) { get '/bettertabs/link_tab_1' } 
    it "has a 200 status code" do
      response.status.should be(200)
    end
    
    it "should not include the attribute data-ajax-url in link tabs" do
      response.body.should_not include("data-ajax-url")
    end
    
  end

  describe "GET /bettertabs/link_tab_2" do
    before(:all) { get '/bettertabs/link_tab_2' } 
    it "has a 200 status code" do
      response.status.should be(200)
    end
  end

  describe "GET /bettertabs/ajax" do
    before(:all) { get '/bettertabs/ajax' } 
    it "has a 200 status code" do
      response.status.should be(200)
    end
    
    it "should include the attribute data-ajax-url in ajax tabs" do
      response.body.should include("data-ajax-url")
    end
    
    it "should include the default ajax=true extra param in the data-ajax-url" do
      response.body.should include("data-ajax-url=\"/bettertabs/ajax/ajax_tab_2?ajax=true\"")
    end
    
    it "should render only the selected tab content" do
      response.body.should include("Content for the ajax_tab_1")
      response.body.should_not include("Content for the ajax_tab_2")
    end
    
    it "should select another tab if requested in the URL" do
      get '/bettertabs/ajax?ajax_selected_tab=ajax_tab_2'
      response.body.should_not include("Content for the ajax_tab_1")
      response.body.should include("Content for the ajax_tab_2")
    end
  end
  
  describe "GET /bettertabs/mixed" do
    before(:all) { get '/bettertabs/mixed' } 
    it "has a 200 status code" do
      response.status.should be(200)
    end
  end
  
  describe "GET /bettertabs/mixed_with_erb" do
    before(:all) { get '/bettertabs/mixed_with_erb' } 
    it "has a 200 status code" do
      response.status.should be(200)
    end
  end 

  
end
