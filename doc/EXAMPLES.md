# Bettertabs Usage and Examples #

## Link Tabs Example ##

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


## Static Tabs Example ##

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


## AJAX tabs ##

Ajax tabs perform an asynchronous call to get the content before showing it. Giving the tab.ajax definition:

    tab.ajax :home, :url => '/home/index', :ajax_url => '/home/ajax_tab'

supposing the bettertabs_id is :mytabs, it will generate the following markup for the tab item:

    <li id="home_mytabs_tab">
      <a data-tab-type="ajax" 
         data-show-content-id="home_mytabs_content" 
         data-ajax-url="/home/ajax_tab" 
         href="/home/index">
         Home
      </a>
    </li>
    
The attributes *data-tab-type*, *data-show-content-id* and *data-ajax-url* will be used by the jquery.bettertabs plugin.

So here there are two important options:

  * :url => The tag link href. Is used to change the browser url (html5 browsers only) and as url when JavaScript is off. Default to current url plus the param `#{bettertabs_id}_selected_tab=#{tab_id}`.
  * :ajax_url => Defaults to :url plus the param `ajax=true`. Is used to perform the ajax request.
  
Both options have a default value, so if you just write:

    tab.ajax :home

supposing the bettertabs_id is :mytabs, and the current url is '/home', it will generate the following markup for the tab item:

    <li id="home_mytabs_tab">
      <a data-tab-type="ajax" 
         data-show-content-id="home_mytabs_content" 
         data-ajax-url="/home?mytabs_selected_tab=home&ajax=true" 
         href="/home?mytabs_selected_tab=home">
         Home
      </a>
    </li>

In the controller you can check if you are receiving an ajax request just looking `if params[:ajax].present?`, or also using `request.xhr?` (that is a header that jQuery uses when perform an ajax request).

**Note**: The :url and :ajax_url values should not be the same because some browsers fetch the cache by url (ignoring the xhr header), and if we use the same url, we may go to a page and see the last ajax response instead of the whole page.


### Improve the Static Tabs Example with ajax ###

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

### The Controller Side ###

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
        
        # When ajax, render only the selected tab content (handled by bettertabs helper)
        render :partial => 'mytabs' and return if request.xhr? # you can also check if params[:ajax].present?
      end

    end

The only needed code in the controller to make it work with ajax is the `render :partial => 'mytabs' and return if request.xhr?` line.

Since the *mytabs* partial just contains the bettertabs helper, and bettertabs helper will just render the selected content when request.xhr?, this line is enough to return the selected content to the ajax call, no matter which tab is selected (because it uses params[:mytabs_selected_tab] to select the right content to render).


### Advantages of having the bettertabs helper alone in a separated partial ###

  * It works without JavaScript out-of-the-box (using default values)
  * Since the URL is changed in the browser when a tab is clicked and it works without JavaScript, a permalink is defined for each tab, so it allows:
    * to bookmark the page on any selected tab
    * to reload the page keeping the selected tab
    * to send the link to other person and he/she will open the selected tab
  * Easily change the behavior of a tab to be `ajax`, `static` or `link`. It always work.
  * Keep your views DRY, clean and readable
  

## Example using HAML and ruby1.9.2 ##

Is easy to mix all types of tabs, and customize them using the provided options:
  
    = bettertabs :bettertabs_example, :selected_tab => :chooseme, :class => 'bettertabs example', :list_html_options => {:class => 'list_class'} do |tab|
    
      = tab.static :simplest_tab, class: 'awesome-tab' do
        Click this tab to see this content.
        
      = tab.static :chooseme, 'Please, Click me!' # as default, renders partial: 'chooseme'
        
      = tab.static :render_another_partial, partial: 'another_partial'
      
      = tab.link :link_to_another_place, url: go_to_other_place_url  # will make a new request
        
      = tab.ajax :cool_ajax, ajax_url: remote_call_path, partial: 'cool_partial'
      -# In this case, you shoud take care of that remote_call_path is using the same partial: 'cool_partial'
      
      = tab.ajax :album, url: url_for(@album), partial: 'shared/album'
      -# This one will make the ajax call to the ajax_url: url_for(@album, :ajax => true)
      
      = tab.ajax :ajax_tab, title: 'Content is loaded only once'


## More documentation ##

  * [Main README document](https://github.com/agoragames/bettertabs/blob/master/README.md)
  * [Bettertabs Styles reference guide](https://github.com/agoragames/bettertabs/blob/master/doc/STYLESHEETS-GUIDE.md)
  * [Bettertabs helper](https://github.com/agoragames/bettertabs/blob/master/app/helpers/bettertabs_helper.rb) (params and options)
  * [Rails3 test demo application](https://github.com/agoragames/bettertabs/tree/master/spec/dummy)
  * Anyway, don't be afraid of digging into the code, it's very straightforward.
