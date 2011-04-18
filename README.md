Bettertabs
==========

Bettertabs is a helper for Rails that renders the markup for a tabbed area in a easy and declarative way, forcing you to keep things simple and ensuring accessibility and usability, no matter if the content is loaded statically or via ajax.


## Important NOTE ##
This gem is in its initial development phase. Not ready to use yet.


## Requirements: ##
  * Ruby 1.9.2
  * Rails 3
  * HAML
  * Bettertabs jQuery plugin (that requires jQuery) (TODO: create the plugin)
  
Although you can use bettertabs without javascript, and also should be possible to use another javascript for this, since the bettertabs helper only generates the appropiate markup.

## Key Points ##

  * Simplicity. Easy to install and easy to use.
  * Forces you to DRY-up your views for your tabbed content.
  * Forces you to make it awesome accessible:
    * If uses Ajax to load content, it will work even when JavaScript is disabled (using a fallback links solution).
    * When click on a tab, the address bar url is changed, so:
      * The browser's back and reload buttons will still work as expected.
      * All tabbed sections can be permalinked, keeping the selected tab.
  * Flexible and customizable.
  * Keep your views testing simple. Thanks to the disabled-javascript feature, you can assert view components with the rails built-in functional and unit tests.
  * The CSS styles are up to you.

## Install ##

Gem dependency. Add bettertabs to your gem file and run `bundle install`.

    gem 'bettertabs'
  

TODO: install BetterTabs jQuery plugin
TODO: instructions to install in Rails 2
  

## Usage and examples ##

Bettertabs supports three kinds of tabs:

  * **Static Tabs**: (requires JavaScript) Load all the content for all tabs, and then show only the selected tab's content when click (using JavaScript). When javascript disabled, it behaves like *link tabs*.
  * **Link Tabs**: Tabs are links, when click go to other page that shows the same tabs but different active content. Only renders the active content. No JavaScript needed.
  * **Ajax Tabs**: Loads only the active tab, and when click on another tab, loads its content via ajax and show. When JavaScript disabled, it behaves like *link tabs*.


### The Simplest Example ###

A simple tabbed content can be created using static tabs.

In view `app/views/home/simple.html.erb`:

    <% bettertabs :simpletabs do |tab| %>
      <%= tab.link :tab1, 'Tab One' do %>
        Hello world.
      <% end %>
      <%= tab.link :tab2, 'Tab Two' do %>
        This is the <b>dark side</b> of the moon.
      <% end %>
    <% end %>


This will define a linked two-tabs widget. The second tab ("Tab Two") is a link to the same url, but with the extra param `:simpletabs_selected_tab` having the value "tab2", that will make the bettertabs helper activate the :tab2 tab.

In this case no JavaScript is required, and a new request will be performed when click the tabs links.
To change this to a javascript static tabs, is only needed to change the `tab.link` declarations for `tab.static`.
To change to ajax tabs, in this case, is only needed to change the `tab.link` declarations for `tab.ajax`.


### Static content ###

This example will show three tabs: "Home", "Who am I?" and "Contact Me".
The partials and files organization used in this examples are not mandatory but recommended, it will make easier to use ajax loaded tabs if needed.

In view `app/views/home/index.html.erb`:

    <%= render 'mytabs' %>

In partial `app/views/home/_mytabs.html.erb`:

    <% bettertabs :mytabs do |tab| %>
      <%= tab.static :home do %>
        <h2>Home</h2>
        <%= raw @content_for_home %>
      <% end %>
      <%= tab.static :about, 'Who am I?', :partial => '/shared/about' %>
      <%= tab.static :contact_me %>
    <% end %>
     

The :about and :contact_me tabs will get the content from the referenced partials. Put any content there, for example:

In partial `app/views/shared/_about.html.erb`:

    Hello, my name is <%= @myname %>.

In partial `app/views/home/_contact_me.html.erb`:

    <h2>How to contact me:<h2/>
    <p><%= @contact_info.inspect %></p>
    
In controller `app/controllers/home_controller.rb`:

    class HomeController < ApplicationController

      def index
        @content_for_home = very_slow_function()
        @myname = 'Lucifer'
        @contact_info = { :address => 'The Hell', :telephone => '666'}
      end

    end

This will work with and without JavaScript, anyway, all vars and content should be loaded in the request.


### Improve with AJAX ###

The previous example has to declare `@content_for_home = very_slow_function()` even if the user only want to see another tab content. To improve this, we can declare this tab as ajax tab, so the content is rendered only when this tab is active (on load or when the user clicks on this tab). In fact, we can change all tabs to ajax.

In view `app/views/home/index.html.erb`:

    <%= render 'mytabs' %>

In partial `app/views/home/_mytabs.html.erb`:

    <% bettertabs :mytabs do |tab| %>
      <%= tab.ajax :home do %>
        <h2>Home</h2>
        <%= raw @content_for_home %>
      <% end %>
      <%= tab.ajax :about, 'Who am I?', :partial => '/shared/about' %>
      <%= tab.ajax :contact_me %>
    <% end %>
     
Note that the only difference in the bettertabs helper is the `tab.ajax` declaration instead of `tab.static`.

Partials `app/views/shared/_about.html.erb` and `app/views/home/_contact_us.html.erb` (same as before).
    
In controller `app/controllers/home_controller.rb`, you can load only the needed data for each tab.

    class HomeController < ApplicationController

      def index
        # Execute only the selected tab needed code (optimization).
        case params[:mytabs_selected_tab]
        when 'home' then
          @content_for_home = very_slow_function()
        when 'about' then
          @myname = 'Lucifer'
        when 'contact_us' then
          @contact_info = { :address => 'The Hell', :telephone => '666'}
        end
        
        # When ajax, load only the selected tab content (handled by bettertabs helper)
        respond_to do |format|
          format.js { render :partial => 'mytabs' }
        end
      end

    end

The only needed code in the controller to make it work with ajax is the `format.js { render :partial => 'mytabs' }` line.

Since the *mytabs* partial only contains the bettertabs helper, and bettertabs helper only renders the selected content, this line is enough to return the selected content to the ajax call. Furthermore this will still work without javascript, allowing to reload the page keeping the selected tab and sending the URL to someone that can load the page in the same tag.


### Mixed Example ###

Is easy to mix all types of tabs, and customize them using the provided options. For example (Using ruby 1.9.2 with HAML):
  
    - bettertabs :example, :selected_tab => :chooseme do |tab|
      - tab.static :simplest_tab, class: 'awesome-tab' do
        Click this tab to see this content.
        
      - tab.static :chooseme, 'CUSTOM TAB CONTENT' # as default, renders partial: 'the_two'
        
      - tab.static :use_another_partial, partial: 'other_partial'
      
      - tab.link :link_to_another_place, url: go_to_other_place_url  # will make a full new request
        
      - tab.ajax :simple_ajax, title: 'Content is only loaded when needed, and will be loaded only once.'
      
      - tab.ajax :album, url: show_remote_album_path, partial: 'shared/album'
        

From the Controller:

The default tab :url option value is the current path but with `param[:"{bettertabs_id}_selected_tab"]` to the current tab id.
This means that, by default, you can handle all needed information in the same controller action for all tab contents. Of course you can change this using a different value for the :url option.

If the tab is ajax, the ajax call will be performed to the same url provided in the :url option.
You can know if a call is ajax checking if `controller.request.xhr?` is true.

So, if `request.xhr?` is *true* then you should render a partial.
If `request.xhr?` is *false* then you can just render the action as usual, bettertabs helper will auto select the appropriate tab based on `params[:"{bettertabs_id}_selected_tab"]` value.

When a call is AJAX, the bettertabs helper only returns the selected content (no tabs, no other content), that way, if you put the bettertabs declaration in a separate partial, you can select the partial simply rendering that partial.

So, you can write your controller code as follows, assuming that bettertabs_id is :example, and it's placed alone in the partial 'bettertabs_example':

    def show_bettertabs_example
      @common_for_all_tabs = code_here
    
      # A simple way of execute code only for the selected tab.
      # Note that static tabs are always rendered, even if they are not selected.
      case params[:example_selected_tab]
      when 'chooseme' then
        code_only_for_this_tab
      else
        code_for_all_other_tabs
      end
      
      # Ready for ajax ...
      # You can check request.xhr? or use the common method respond_to
      respond_to do |format|
        format.js { render :partial => 'bettertabs_example' }
      end
    end



## TODO ##

  * Create a Rails testing application.
    * Start with manual testing, but create a spec sheet to assert.
    * Later, it should use rspec and capybabra to test even the javascript (http://media.railscasts.com/videos/257_request_specs_and_capybara.mov)
    * Ensure that bettertabs work with ERB and ruby 1.8.x
  * Add the JavaScript functionality
    * Find a jQuery plugin to handle address bar url change, just like Github does.
    * Create bettertabs jQuery plugin
  * Improve examples and documentation in this Readme file. Keep it simple.
  * Create a basic CSS stylesheet that may serve as base
  
  
## Current Spec sheet (will become automatic tests) ##
  * Should always work with javascript disabled (using the urls of the tabs links)
  * The bettertabs hepler should accept:
    * args: (bettertabs_id, options)
    * options can be:
       * :selected_tab => tab_id to select by default
         * :selected_tab should be overridden with params[:"#{bettertabs_id}_selected_tab"] if present
       * any other option is used as wrapper html_options (wrapper is the top-level widget dom element).
  * The bettertabs helper should render clear markup:
     * A wrapper with class 'bettertabs'
     * Tabs markup
        * ul.tabs > li > a  
        * selected tab is ul.tabs > li.active > a
        * each a element has element attributes:
           * data-tab-type (for javascript: change click behavior depending on type "static", "link" or "ajax")
           * data-show-content-id (for javascript: element id to show when select this tab)
     * sections for each tab content.
     * use a unique html id (based on bettertabs_id and tab_id) for each Tab and Content
  * The bettertabs builder ".from" method should accept:
     * args: (tab_id, tab_name, options, &block)
     * args: (tab_id, options, &block)
    * If block_given? the block is used as content related to this tab
     * options can be:
       * :partial => to use as content. Defaults to tab_id
          * if block_given? this option can not be used (if used, raise an error)
       * :url => for the tab link, that should go to this selected tab when javascript is disabled. Defaults to { :"#{bettertabs_id}_selected_tab" => tab_id }
       * :tab_type => used in the markup as the link data-tab-type value. Can be :static, :link or :ajax (or the corresponding strings). Raise error otherwise. Defaults to :static.
  * The bettertabs builder ".static", ".link" and ".ajax" methods are only a convenient way to use ".for" method with :tab_type set to :static, :link or :ajax respectively.
  * Content is rendered only for active tab, except when tab_type is :static, where content is always rendered (ready to show when select that tab using javascript).
  * When ajax call (format.js), the bettertabs helper should return ONLY the content of the selected tab (to simplify the controller render partial calls.).

