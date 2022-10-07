Bettertabs Changelog
====================

### v1.5.1 (2022-10-07)

  * Adds support for Rails 6 (removes support for older Rails versions)
   
### v1.4.2 (2014-11-10)

  * Add option :list_item_html_options to specify the attributes on the rendered li elements for tabs. Thanks (@jskinner-arpc).

### v1.4.1 (2013-02-27)

  * Ensure BettertabsHelper is included even if config.action_controller.include_all_helpers is false, https://github.com/agoragames/bettertabs/pull/13

### v1.4 (2012-06-18) ###

  * Upgrade notes
    * The bettertabs helper no longer generates javascript inline to apply the jquery pluging. If you update you need to add the javascript yourself (something like `jQuery('.bettertabs').bettertabs();` in your application.js file), or you can add an initializer to set the attach_jquery_bettertabs_inline option to true (see README).
  * Add possibility to define default options (only attach_jquery_bettertabs_inline for now) in an initializer, https://github.com/agoragames/bettertabs/pull/6. Thanks (@manuelmeurer). Then set the attach_jquery_bettertabs_inline option to false by default.
  * Allow to include content blocks that do not have tabs with `tab.only_content_block`. Inspired by https://github.com/agoragames/bettertabs/pull/7 by (@manuelmeurer)
  * Add option :locals on tab definition. https://github.com/agoragames/bettertabs/pull/9. Thanks (@pdf)
  * Add option :list_html_options to allow specifying :html_options for the :ul element, https://github.com/agoragames/bettertabs/pull/10. Thanks (@pdf)

### v1.3.6 (2012-03-12) ###

  * Adds support for Rails 3.2, https://github.com/agoragames/bettertabs/pull/3. Thanks (@jlee42).

### v1.3.5 (2011-09-13) ###

  * Add 'active' class to the link element inside the active tag as well as the li element (so it is now more easy to style)
  * When tab-type is ajax, mark the first active link as content-loaded-already to not be loaded again when click later
  * Ajax error handling: when .load() callback returns a textStatus 'error', the browser is reloaded to better show the error
  * Bugfix: include other params if present in the default tab link url

### v1.3 (2011-09-12) ###

  * Gem converted into a Rails 3.1 Engine that uses the asset pipeline to serve the jquery.bettertabs plugin
  * Test dummy app converted to Rails 3.1

### v1.2.3 (2011-06-23) ###

  * Tested with Rails 3.0.9 and HAML 3.1.2
  * Bugfix on the bettertabs helper inline script, avoid to add it as an HTML attribute

### v1.2.1 (2011-05-02) ###

  * Bugfix on the bettertabs helper inline script

### v1.2 (2011-05-02) ###

  * Added :attach_jquery_bettertabs_inline option to the helper, defaults to true. If false, do not render the inline script that activates the plugin.
  * Bettertabs jQuery plugin improvement:
    * Exposed the change_browser_url method to global access in jQuery.Bettertabs.change_browser_url(url), so it can be used and overwritten by other scripts
    * Created the jQuery.Bettertabs.select_tab(bettertabs_id, tab_id) method to easily select a tab from other scripts
    * Improved the README.md JavaScript section with more clear examples

### v1.1 (2011-04-28) ###

  * Added :ajax_url option to tab builder, defaults to :url plus the ajax=true param to prevent browser cache issues.
  * bettertabs helper :class html_option replace the 'bettertabs' default class instead of adding it (there was no way to remove that class).
  * Bugfix: don't add .hidden CSS class to non active tabs (it should only be added to non active content).
  * Documentation improvement:
    * Added jquery.bettertabs documentation (REAMDE.md)
    * Added some CSS examples and documentation (lib/bettertabs/stylesheets/README.md)
    * README.md review and clean-up, moved examples to EXAMPLES.md.
    * Added Routes examples (README.md)
    * Added bettertabs helper documentation (params and options in the method comment)

### v1.0 (2011-04-22) ###

  * bettertabs rails helper, with static, link and ajax tabs
  * jquery.bettertabs plugin, that activate the clicked tab, loads ajax content and change the url using HTML history.replaceState() javascript method.
  * README.md documentation improved with examples
  * Rails3 (ruby 1.9.2) test application (in the test folder) with some use cases and some basic rspec tests.

### v0.0.1 (2011-03-31) ###

  * Initial development and structure for the gem
  * Initial documentation (README.md file)
