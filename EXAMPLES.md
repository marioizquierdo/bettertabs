## Bettertabs Usage and Examples ##

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


### Static Tabs Example ###

This example will show three tabs: "Home", "Who am I?" and "Contact Me".
The partials and files organization used in this examples are not mandatory but recommended, to make the change to ajax tabs very easy if needed.

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

Partials `app/views/shared/_about.html.erb` and `app/views/home/_contact_us.html.erb` (same as in the *static tabs example*).
    
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
    * to send the link to other person and he/she will open the selected tab
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
        
      = tab.ajax :simple_ajax, ajax_url: remote_call_path(tab: 'simple_ajax'), title: 'Content is loaded when needed and only once.'
      
      = tab.ajax :album, url: url_for(@album), partial: 'shared/album'


#### From the Controller: ####

The default tab :url option value is the current path but with `param[:"{bettertabs_id}_selected_tab"]` to the current tab id.
This means that, by default, you can handle all needed information in the same controller action for all tab contents. Of course you can change this using a different value for the :url option.

If the tab is ajax, the ajax call will be performed to the same url provided in the :url option.
You can know if a call is ajax checking if `controller.request.xhr?` is true.

So, if `request.xhr?` is *true* then you should render a partial to be used as content.

If `request.xhr?` is *false* then you can just render the action as usual, bettertabs helper will auto select the appropriate tab based on `params[:"{bettertabs_id}_selected_tab"]` value.

When a call is AJAX, the bettertabs helper only render the active content (no tabs, no wrappers, no other content), so you can just render the partial where the bettertabs helper is used and it will work for any selected tab.

You can write your controller code as follows, assuming that bettertabs_id is :example, and it's placed alone in the partial `bettertabs_example`:

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


### More documentation ###

  * [Main README document](https://github.com/agoragames/bettertabs/blob/master/README.md)
  * [Bettertabs Styles reference guide](https://github.com/agoragames/bettertabs/blob/master/lib/bettertabs/stylesheets/README.md)
  * [Bettertabs helper](https://github.com/agoragames/bettertabs/blob/master/lib/bettertabs/bettertabs_helper.rb) (params and options)
  * [Rails3 test demo application](https://github.com/agoragames/bettertabs/tree/master/test/ruby_1_9/rails_3_0)
  * Anyway, don't be afraid of digging into the code, it's very straightforward.