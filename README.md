Bettertabs
==========

Bettertabs is a helper for Rails that renders the markup for a tabbed area in a easy and declarative way, forcing you to keep things simple and ensuring accessibility and usability, no matter if the content is loaded statically or via ajax.


### Important NOTE ###
This gem is in its initial development phase. Not ready to use yet.


### Requirements: ###
  * Ruby 1.9.2
  * Rails 3
  * HAML
  * Bettertabs jQuery plugin (that requires jQuery) (TODO: create the plugin)
  
Although you can use bettertabs without javascript, and also should be possible to use another javascript for this, since the bettertabs helper only generates the appropiate markup.

### Key Points ###

  * Simplicity. Easy to install and easy to use.
  * Forces you to DRY-up your views for your tabbed content.
  * Forces you to make it awesome accessible:
    * If uses Ajax to load content, it will work even when JavaScript is disabled (using a fallback links solution).
    * When click on a tab, the address bar url is changed, so:
      * The back and reload buttons will still work as expected.
      * All tabbed sections can be permalinked, keeping the selected tab.
  * Flexible and customizable.
  * Keep your views testing simple. Thanks to the disabled-javascript feature, you can assert view components with the rails built-in functional and unit tests.
  * The CSS styles are up to you.

### Install ###

Gem dependency. Add bettertabs to your gem file and run `bundle install`.

    gem 'bettertabs'
  

TODO: install BetterTabs jQuery plugin
  

### Usage and examples ###

Bettertabs supports three kinds of tabs:

  * **Static Tabs**: (requires JavaScript) Load all the content for all tabs, and then show only the selected tab's content when click (using JavaScript). When javascript disabled, it behaves like *link tabs*.
  * **Link Tabs**: Tabs are links, when click go to other page that shows the same tabs but different active content. Only renders the active content. No JavaScript needed.
  * **Ajax Tabs**: Loads only the active tab, and when click on another tab, loads its content via ajax and show. When JavaScript disabled, it behaves like *link tabs*.


#### Simple static tabs ####


#### Large Example ####

View helpers example (ruby 1.9.2 with HAML)
  
    - bettertabs :panel, :selected_tab => :static_tab do |tab|
      - tab :simplest_tab do
        Content for the tab 1
        
      - tab :static_tab, 'CUSTOM TAB CONTENT', 
          title: 'Click this tab to see the content inside', class: 'awesome-tab-link' do
        Static content for the second tab.
        = render 'content_from_a_partial'
        
      - tab :static_tab_with_partial, partial: 'render_partial_content'
      
      - tab :link_to_another_place, url: go_to_other_place_url
      
      - tab :link_and_show_if_selected, url: show_this_tab_in_other_page_path(:panel_selected_tab => 'link_and_show_if_selected') do
        Content that is only rendered if this tab is selected.
        Note that instead of using a block, you can use the :partial option (that points to a partial).
        This kind of tabs may be useful if the tabs_widget is in a isolated partial and then rendered from different views.
      
      - tab :link_to_self_action, url: {:panel_selected_tab => 'link_to_self_action'} do
        Pointing all tabs to the same action we can use a case statement in the controller.
        Within this helper, the param[:panel_selected_tab] (used :panel because the tabs_widget id is :panel) chooses the current selected tab.
        If no param is given, then use the tabs_widget :selected option (which defaults to the first tab).
        Since this should be a common behavior, we can use the tab_link instead (next example)
      
      - tab_link :common_link_to_self, partial: 'use_a_partial_instead_of_a_block'
        
      - tab :ajax_link, url: load_content_for_this_tab_path, remote: true, title: 'Content is only loaded on first click' do
        Using a block in a ajax link (that is ajax thanks to the unobtrusive option :remote => true) has no sense,
        because the remote action will render a partial, and this tab should use the same partial in the :partial option.
        Since using an ajax tab pointing to the same action (with the :panel_selected_tab param pointing to this tab id) and to the same partial
        as in the controller should be a common practice, we provide the ajax_tab helper (next example)
      
     -# This three examples are equivalent (they use the same tab_id because this is an example)
      - ajax_tab :simple, 'Accessible', title: 'AJAX'
      - tab_link :simple, 'Accessible', title: 'AJAX', partial: 'simple', remote: true
      - tab :simple, 'Accessible', title: 'AJAX', url: { panel_selected_tab: 'simple' }, partial: 'simple', remote: true

From the Controller:
If tab is ajax, then controller.request.xhr? is true.

So if request.xhr? is false then you can just render the action as usual, bettertabs helper will auto select the appropriate tab because of the `param[:"{tabs_widget_id}_selected_tab"]` value.

If request.xhr? is true then render a partial, for example render :partial => 'simple'.

So, you can write your controller code as follows (assuming that tabs_widget is :panel)

    def show_tabbed_content
      @common_for_all_tabs = code_here
    
      case params[:panel_selected_tab]
      when 'simple' then
        code_only_for_this_tab
      else
        code_for_all_other_tabs
      end
      
      # You can check request.xhr? or use the common method respond_to
      respond_to do |format|
        format.js { render :partial => params[:panel_selected_tab] }
      end
    end



### TODO ###

  * Create a Rails testing application.
    * Start with manual testing, but create a spec sheet to assert.
    * Later, it should use rspec and capybabra to test even the javascript (http://media.railscasts.com/videos/257_request_specs_and_capybara.mov)
  * Add the JavaScript functionality
    * Find a jQuery plugin to handle address bar url change, just like Github does.
    * Create bettertabs jQuery plugin
  * Improve examples and documentation in this Readme file. Keep it simple.
  * Create a basic CSS stylesheet that may serve as base
