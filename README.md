Bettertabs for Rails
====================

We know that splitting content into several tabs is easy, but doing well, clean, DRY, accessible, usable, fast and testable is not so simple after all.

Bettertabs is a helper for Rails that renders the markup for a tabbed area in a easy and declarative way, forcing you to keep things simple and ensuring accessibility and usability, no matter if the content is loaded statically or via ajax.

Easy for beginners, complete for experts.


## Features ##

  * Rails helper to easily generate tabs and content markup
  * Provides a jQuery plugin to handle the JavaScript behavior
  * Simplicity: Easy to install and easy to use
  * Flexible and customizable
  * Forces you to DRY-up your views for your tabbed content
  * Forces you to make it awesome accessible and usable:
    * Designed to work with and without JavaScript
    * When click on a tab, the address bar url is changed (only in HTML5 browsers), so:
      * The browser's back and reload buttons will still work as expected
      * All tabbed sections can be permalinked, keeping the selected tab
  * Makes testing views simple. Because its easy to make it works without javascript, you can assert view components with the rails built-in functional and integration tests
  * The CSS styles are up to you


## Requirements: ##
  * Ruby 1.9.2
  * Rails 3
  * [jQuery](http://jquery.com/) 1.3 or higher, in order to use the [Bettertabs jQuery plugin](https://github.com/agoragames/bettertabs/raw/master/lib/bettertabs/javascripts/jquery.bettertabs.min.js)

Anyway you can use bettertabs without javascript (or use your own javascript handler) since the bettertabs helper only generates the appropriate markup.


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

An usage example should be self explanatory (using HAML, but it also works with ERB and other template systems):

    = bettertabs :profile_tabs do |tab|
      = tab.static :general, 'My Profile' do
        %h2 General Info
        = show_user_general_info(@user)
          
      = tab.ajax :friends, :partial => 'shared/friends'
      
      = tab.link :groups do
        =  render :partial => 'groups/user_groups', :locals => {user => @user}

### More examples and documentation: ###

  * [EXAMPLES document](https://github.com/agoragames/bettertabs/blob/master/EXAMPLES.md)
  * [Bettertabs Styles reference guide](https://github.com/agoragames/bettertabs/blob/master/lib/bettertabs/stylesheets/README.md)
  * [Bettertabs helper](https://github.com/agoragames/bettertabs/blob/master/lib/bettertabs/bettertabs_helper.rb) (params and options)
  * [Rails3 test demo application](https://github.com/agoragames/bettertabs/tree/master/test/ruby_1_9/rails_3_0)
  * Anyway, don't be afraid of digging into the code, it's very straightforward.
  

## Tabs Routes ##

By default, all tab links have the current url plus the `{bettertabs_id}_selected_tab` param with the tab_id value.

For example, if you are rendering the next bettertabs widget:

    = bettertabs :profile_tabs do |tab|
      = tab.static :general
      = tab.static :friends

in a view accessible by a route like this:

    match 'profile/:nickname', :to => 'profiles#lookup', :as => 'profile'

When you go to `/profile/dude`, your tabs links will have the following hrefs: 

  * :general tab href: `/profile/dude?profile_tabs_selected_tab=general`
  * :friends tab href: `/profile/dude?profile_tabs_selected_tab=friends`

If you're in a modern HTML5 browser then when click on a tab, the URL will change for one of the urls listed before (jquery.bettertabs), otherwise, you can turn the JavaScript off and the static tabs will become link tabs, so the URL will change as well.

To show a pretty url, you can just modify your named route to:

    match 'profile/:nickname(/:profile_tabs_selected_tab)', :to => 'profiles#lookup', :as => 'profile'

So now the tabs links will point to the following URLs:

  * :general tab href: `/profile/dude/general`
  * :friends tab href: `/profile/dude/friends`
  
  
## JavaScript with the jquery.bettertabs plugin ##

Installing the `bettertabs` gem in a rails project makes the bettertabs helper instantly available. This helper will generate markup that is prepared to be modified by JavaScript, and also includes an inline script at the bottom:

    jQuery(function($){ $('#bettertabs_id').bettertabs(); });

Which expects jQuery and jquery.bettertabs plugin to be loaded.

The jquery.bettertabs plugin can be downloaded directly from the github repo:

  * [CoffeeScript version](https://github.com/agoragames/bettertabs/raw/master/lib/bettertabs/javascripts/jquery.bettertabs.coffee)
  * [JavaScript (generated by coffee) version](https://github.com/agoragames/bettertabs/raw/master/lib/bettertabs/javascripts/jquery.bettertabs.js)
  * [Compressed JavaScript](https://github.com/agoragames/bettertabs/raw/master/lib/bettertabs/javascripts/jquery.bettertabs.min.js)
  
The plugin defines one single jQuery method `jQuery(selector).bettertabs();` that is applied to the generated markup.

This script will take the tab type from each tab link `data-tab-type` attribute (that can be "link", "static" or "ajax"), and will match each tab with its content using the tab link `data-show-content-id` attribute, that is the id of the related content.

Tabs of type "link" will be ignored, while "static" and "ajax" tabs will change the active content (using the `.active` css class), and also will try to change the current URL (browser history state)


### Browser history and url manipulation ###

When a tab is clicked, the plugin attempts to change the browser url to the tab link url to reflect the page state.

To change the url, the plugin defines the method `jQuery.Bettertabs.change_browser_url(new_url)`, that is internally called each time a tab is activated. This method is implemented using [history.replaceState()](https://developer.mozilla.org/en/DOM/Manipulating_the_browser_history), which only works on modern HTM5 browsers (older browsers can not change the URL, and I prefer not trying to use History.js or any other approach to give them support for them).

The *jQuery.Bettertabs.change_url(url)* method is public, so it can be reused for other scripts (for example if you want to implement your own ajax pagination links inside the tab, and you want to reflect it in the browser bar). This also means that you can rewrite this method with your own implementation (to use another plugin like [History.js](https://github.com/balupton/history.js), [jQuery BBQ](http://benalman.com/projects/jquery-bbq-plugin/), or [HTML5 pushState](https://developer.mozilla.org/en/DOM/Manipulating_the_browser_history) on your own if you want to change the browser url).


### Play with the bettertabs widget from other scripts ###

All parts of the bettertabs generated markup are identified using ids, so it is very easy to identify and modify any part of the inner content (just open your firebug and browse the generated markup).

You can interact with the bettertabs widget in the following ways:

  * **Activate a tab**: use the function `jQuery.Bettertabs.select_tab(bettertabsid, tabid);`, for the previous example could be *jQuery.Bettertabs.select_tab('profile_tabs', 'friends');*. You can also just simulate a click on the tab link with `jQuery('#tabid_bettertabsid_tab a').click();`
  * **Hook some behavior when a tab is clicked**: attach a 'click' handler to the tab link or use any of the provided custom events.
  * **Show a loading clock while ajax is loading**: or any other kind of feedback to the user, use any of the provided custom events. You can also handle it styling the CSS class `.ajax-loading` that is added to the ajax tab link while ajax content is loading (see the [Styles Reference Guide](https://github.com/agoragames/bettertabs/blob/master/lib/bettertabs/stylesheets/README.md))
  * **Change the browser URL**: in the same way the plugin does when a tab is clicked, use `jQuery.Bettertabs.change_browser_url(new_url);`
  
Custom events that are attached to each tab content:

  * *'bettertabs-before-deactivate'*:   fired on content that is active and will be deactivated
  * *'bettertabs-before-activate'*:     fired on content that will be activated
  * *'bettertabs-before-ajax-loading'*: fired on content container that will be activated just before be loaded using ajax
  * *'bettertabs-after-deactivate'*:    fired on content that was deactivated
  * *'bettertabs-after-activate'*:      fired on content that was activated
  * *'bettertabs-after-ajax-loading'*:  fired on content after it was loaded via ajax. Remember that the content is loaded via ajax only once.

Usage example of custom events:

    // Show an alert when the :friends tab content of the :profile_tabs is activated and visible
    $("#profile_tabs_friends_content").bind('bettertabs-after-activate', function(){
      alert('friends content is visible');
    });
    
    // Display the $('#loading-clock') element while ajax tabs are loading
    $("#profile_tabs").bind('bettertabs-before-ajax-loading', function(){
      $('#loading-clock').show();
    }).bind('bettertabs-after-ajax-loading', function(){
      $('#loading-clock').hide();
    });


## CSS Styles ##

Bettertabs provides a rails helper to generate HTML and a jQuery plugin as JavaScript, but not any CSS styles because those are very different for each project and can not be abstracted into a common purpose CSS stylesheet.
  
Perhaps the most important CSS rule here is to define `display: none;` for `div.content.hidden`, because contents are never hidden using the jquery.hide() method or similar. The jquery.bettertabs plugin just adds the `.active` class to the active tab and active content, and the `.hidden` class to the non active content. You will need to use a CSS rule like this:

      div.bettertabs div.content.hidden { display: none; }

Use the [Bettertabs Styles Reference Guide](https://github.com/agoragames/bettertabs/blob/master/lib/bettertabs/stylesheets/README.md) to get a stylesheet that you can use as a starting point.


## Future work ##

  * Improve the Rails testing application: it should use rspec and capybabra to test even the javascript (http://media.railscasts.com/videos/257_request_specs_and_capybara.mov)
  * Try to make it compatible with ruby 1.8.x
  
