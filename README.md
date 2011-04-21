Bettertabs
==========

We know that splitting content into several tabs is easy, but doing well, clean, DRY, accessible, usable, fast and testable is not so simple after all.

Bettertabs is a helper for Rails that renders the markup for a tabbed area in a easy and declarative way, forcing you to keep things simple and ensuring accessibility and usability, no matter if the content is loaded statically or via ajax.


## Features and Key Points ##

  * Generate markup with a rails helper and add JavaScript behavior with a jQuery plugin
  * Simplicity: Easy to install and easy to use
  * Forces you to DRY-up your views for your tabbed content
  * Forces you to make it awesome accessible and usable:
    * Designed to work with and without JavaScript
    * When click on a tab, the address bar url is changed (feature supported only in HTML5 browsers), so:
      * The browser's back and reload buttons will still work as expected
      * All tabbed sections can be permalinked, keeping the selected tab
  * Flexible and customizable
  * Makes testing views simple. Because it works without javascript, you can assert view components with the rails built-in functional and integration tests.
  * The CSS styles are up to you.


## Requirements: ##
  * Ruby 1.9.2
  * Rails 3
  * The [Bettertabs jQuery plugin](https://github.com/agoragames/bettertabs/raw/master/lib/bettertabs/javascripts/jquery.bettertabs.min.js) (that requires [jQuery](http://jquery.com/) 1.3, 1.4 or 1.5)

Although you can use bettertabs without javascript, and also should be possible to use another javascript for this, since the bettertabs helper only generates the appropiate markup.


## Install ##

Gem dependency. Add bettertabs to your gem file and run `bundle install`.

    gem 'bettertabs'
  

Download the [bettertabs.jquery.min plugin](https://github.com/agoragames/bettertabs/raw/master/lib/bettertabs/javascripts/jquery.bettertabs.min.js) (or the [uncompressed version](https://github.com/agoragames/bettertabs/raw/master/lib/bettertabs/javascripts/jquery.bettertabs.js)), put it in your `public/javascripts` folder and include it in your layout after the jQuery library, for example:

    <%= javascript_include_tag 'jquery', 'rails', 'jquery.bettertabs.min' %>

Now you can use the `bettertabs` helper as in the examples below.
    

## Usage and examples ##

Bettertabs supports three kinds of tabs:

  * **Link Tabs**: Loads only the active tab contents; when click on another tab, go to the specified URL. No JavaScript needed.
  * **Static Tabs**: Loads all content of all static tabs, but only show the active content; when click on another tab, activate its related content. When JavaScript disabled, it behaves like *link tabs*.
  * **Ajax Tabs**: Loads only the active tab contents; when click on another tab, loads its content via ajax and show. When JavaScript disabled, it behaves like *link tabs*.


### Link Tabs Example ###

A simple tabbed content can be created using linked tabs:

In view `app/views/home/simple.html.erb`:

    <%= bettertabs :simpletabs do |tab| %>
      <%= tab.link :tab1, 'Tab One' do %>
        Hello world.
      <% end %>
      <%= tab.link :tab2, 'Tab Two' do %>
        This is the <b>dark side</b> of the moon.
      <% end %>
    <% end %>


This will define a linked two-tabs widget. The second tab ("Tab Two") is a link to the same url, but with the extra param `?simpletabs_selected_tab=tab2`, that will make the bettertabs helper activate the :tab2 tab.

In this case no JavaScript is required, and a new request will be performed when click the tabs links.
To change this to a javascript static tabs, you only need to change `tab.link` declarations for `tab.static`.
To change this to ajax tabs, in this case, is only needed to change the `tab.link` declarations for `tab.ajax`.


### Static Tabs Example ###

This example will show three tabs: "Home", "Who am I?" and "Contact Me".
The partials and files organization used in this examples are not mandatory but recommended, it will make easier to change to ajax tabs if needed.

In view `app/views/home/index.html.erb`:

    <h1>Static Tabs Example</h1>
    <%= render 'mytabs' %>

In partial `app/views/home/_mytabs.html.erb`:

    <%= bettertabs :mytabs do |tab| %>
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
        # Declare instance variables as usual
        @content_for_home = very_slow_function()
        @myname = 'Lucifer'
        @contact_info = { :address => 'The Hell', :telephone => '666'}
      end

    end

This will work with and without JavaScript, anyway, all vars and content should be loaded in the request because all static tabs need to render its content.


### Improve with AJAX ###

Ajax tabs call the same URL as link tabs but loading the content asynchronously.

In the previous example, `@content_for_home = very_slow_function()` has to be executed even if the user see another tab content. Using ajax or link tabs, the content is only loaded when needed.

Lets create some tabs with ajax:

In view `app/views/home/index.html.erb`:

    <h1>Ajax Tabs Example</h1>
    <%= render 'mytabs' %>

In partial `app/views/home/_mytabs.html.erb`:

    <%= bettertabs :mytabs do |tab| %>
      <%= tab.ajax :home do %>
        <h2>Home</h2>
        <%= raw @content_for_home %>
      <% end %>
      <%= tab.ajax :about, 'Who am I?', :partial => '/shared/about' %>
      <%= tab.ajax :contact_me %>
    <% end %>
     
**Note** that the only difference between this example and the *static tabs example* is to use `tab.ajax` declaration instead of `tab.static`.

Partials `app/views/shared/_about.html.erb` and `app/views/home/_contact_us.html.erb` (same as the static tabs example).
    
In controller `app/controllers/home_controller.rb`, you can load only the needed data for each tab:

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
          format.js { render :partial => 'mytabs' } # when ajax call, bettertabs only renders the active content.
        end
      end

    end

The only needed code in the controller to make it work with ajax is the `format.js { render :partial => 'mytabs' }` line.

Since the *_mytabs* partial only contains the bettertabs helper, and bettertabs helper only renders the selected content when ajax call, this line is enough to return the selected content to the ajax call.

#### Advantages if you follow this file structure ####

Having the bettertabs helper in a separated partial gives you the following advantages:

  * It works without JavaScript out-of-the-box
  * Since the URL is changed in the browser when a tab is clicked and it works without JavaScript, a permalink is defined for each tab, so it allows:
    * to bookmark the page on any selected tab
    * to reload the page keeping the selected tab
  * Easily change the behavior of a tab to be `ajax`, `static` or `link`. It always work.
  * Keep your views DRY, clean and readable


### Mixed Example ###

Is easy to mix all types of tabs, and customize them using the provided options. For example (Using ruby 1.9.2 with HAML):
  
    = bettertabs :bettertabs_example, :selected_tab => :chooseme do |tab|
      = tab.static :simplest_tab, class: 'awesome-tab' do
        Click this tab to see this content.
        
      = tab.static :chooseme, 'Please, Click me!' # as default, renders partial: 'chooseme'
        
      = tab.static :render_another_partial, partial: 'another_partial'
      
      = tab.link :link_to_another_place, url: go_to_other_place_url  # will make a new request
        
      = tab.ajax :simple_ajax, title: 'Content is loaded when needed and only once.'
      
      = tab.ajax :album, url: show_remote_album_path, partial: 'shared/album'
        

#### From the Controller: ####

The default tab :url option value is the current path but with `param[:"{bettertabs_id}_selected_tab"]` to the current tab id.
This means that, by default, you can handle all needed information in the same controller action for all tab contents. Of course you can change this using a different value for the :url option.

If the tab is ajax, the ajax call will be performed to the same url provided in the :url option.
You can know if a call is ajax checking if `controller.request.xhr?` is true.

So, if `request.xhr?` is *true* then you should render a partial to be used as content.

If `request.xhr?` is *false* then you can just render the action as usual, bettertabs helper will auto select the appropriate tab based on `params[:"{bettertabs_id}_selected_tab"]` value.

When a call is AJAX, the bettertabs helper only render the active content (no tabs, no wrappers, no other content), so you can just render the partial where the bettertabs helper is used and it will work for any selected tab.

You can write your controller code as follows, assuming that bettertabs_id is :example, and it's placed alone in the partial 'bettertabs_example':

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
        format.js { render :partial => 'bettertabs_example' } # render only the selected content
      end
    end



## TODO ##

  * Improve the Rails testing application.
    * it should use rspec and capybabra to test even the javascript (http://media.railscasts.com/videos/257_request_specs_and_capybara.mov)
    * Try to make it work with ruby 1.8.x
  * Create a basic CSS stylesheet that may serve as base (and add the links here in the documentation)
  
  
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

