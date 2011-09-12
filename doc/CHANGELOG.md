Bettertabs Changelog
====================

2011-06-23  Mario Izquierdo Martinez <tothemario@gmail.com>

  * Tag v1.2.3
  * Tested with Rails 3.0.9 and HAML 3.1.2
  * Bugfix on the bettertabs helper inline script, avoid to add it as an HTML attribute

2011-05-02  Mario Izquierdo Martinez <tothemario@gmail.com>

  * Tag v1.2.1
  * Bugfix on the bettertabs helper inline script

2011-05-02  Mario Izquierdo Martinez <tothemario@gmail.com>

  * Tag v1.2
  * Added :attach_jquery_bettertabs_inline option to the helper, defaults to true. If false, do not render the inline script that activates the plugin.
  * Bettertabs jQuery plugin improvement:
    * Exposed the change_browser_url method to global access in jQuery.Bettertabs.change_browser_url(url), so it can be used and overwritten by other scripts
    * Created the jQuery.Bettertabs.select_tab(bettertabs_id, tab_id) method to easily select a tab from other scripts
    * Improved the README.md JavaScript section with more clear examples

2011-04-28  Mario Izquierdo Martinez <tothemario@gmail.com>
  
  * Tag v1.1
  * Added :ajax_url option to tab builder, defaults to :url plus the ajax=true param to prevent browser cache issues.
  * bettertabs helper :class html_option replace the 'bettertabs' default class instead of adding it (there was no way to remove that class).
  * Bugfix: don't add .hidden CSS class to non active tabs (it should only be added to non active content).
  * Documentation improvement:
    * Added jquery.bettertabs documentation (REAMDE.md)
    * Added some CSS examples and documentation (lib/bettertabs/stylesheets/README.md)
    * README.md review and clean-up, moved examples to EXAMPLES.md.
    * Added Routes examples (README.md)
    * Added bettertabs helper documentation (params and options in the method comment)
  
2011-04-22  Mario Izquierdo Martinez <tothemario@gmail.com>

  * Tag v1.0
  * bettertabs rails helper, with static, link and ajax tabs
  * jquery.bettertabs plugin, that activate the clicked tab, loads ajax content and change the url using HTML history.replaceState() javascript method.
  * README.md documentation improved with examples
  * Rails3 (ruby 1.9.2) test application (in the test folder) with some use cases and some basic rspec tests.
  
2011-03-31  Mario Izquierdo Martinez <tothemario@gmail.com>

  * Tag v0.0.1
  * Initial development and structure for the gem
  * Initial documentation (README.md file)