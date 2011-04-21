###
Bettertabs jQuery plugin v0.1

jQuery(selector).bettertabs(); adds javascript to change content when click on tabs.

Markup needed, the same that is generated by the rails bettertabs helper, added by the bettertabs plugin
    https://github.com/agoragames/bettertabs

Events: Each time a tab is selected, some events are fired, so you can easily activate
behavior from another jquery script (using .bind); The available events are:
    'bettertabs-before-deactivate':   fired on content that is active and will be deactivated
    'bettertabs-before-activate':     fired on content that will be activated
    'bettertabs-before-ajax-loading': fired on content that will be activated and needs ajax loading
    'bettertabs-after-deactivate':    fired on content that was deactivated
    'bettertabs-after-activate':      fired on content that was activated
    'bettertabs-after-ajax-loading':  fired on content after it was loaded via ajax

###

$ = jQuery

tab_type_attr = 'data-tab-type' # attribute on tab links that indicate the tab type
show_content_id_attr = 'data-show-content-id' # attribute on tab links that indicate the related content id
tab_type_of = ($tab_link) -> $tab_link.attr(tab_type_attr)
content_id_from = ($tab_link) -> $tab_link.attr(show_content_id_attr)

first_active_tabs = $() # will contain each first_active_tab included in the page

# URL change
History = window.History
using_historyjs = !!History?.enabled # Check History.js included
if using_historyjs # With History.js, we can use pushState and revert when click the back button.
  listen_statechange = on
  allow_change_url = on
  initial_state_id = History.getState().id
  
  History.Adapter.bind window, 'statechange', ->
    if listen_statechange is on
      state = History.getState()
      History.log state.data, state.title, state.url
      
      tab = if state.id is initial_state_id then first_active_tabs else 
        if state.data['bettertabs_tab_id']? then $("##{state.data['bettertabs_tab_id']}") else $()
      allow_change_url = off
      tab.children('a').click()
      allow_change_url = on

  change_url = ($link) ->
    if allow_change_url is on
      listen_statechange = off
      History.pushState {'bettertabs_tab_id': $link.parent().attr('id')}, document.title, $link.attr('href')
      listen_statechange = on

else

  # Without History.js, we can use replaceState for HTML5 browsers, and just ignore for old browsers (no change url support).
  # This will work on last Firefox and Chrome browsers, but I could not find a easy way to listen the popstate event,
  # so is better not to use pushState (because we can no revert to previous stata), replaceState just works fine.
  change_url = ($link) ->
    if history? and history.replaceState?
      url = $link.attr 'href'
      history.replaceState null, document.title, url


$.fn.bettertabs = ->
  @each ->
    mytabs = $(this)
    tabs = mytabs.find 'ul.tabs > li'
    tabs_links = mytabs.find 'ul.tabs > li > a'
    tabs_contents = mytabs.children '.content'
    tabs_and_contents = tabs.add tabs_contents
    first_active_tab = tabs.filter '.active'
    first_active_tabs = first_active_tabs.add(first_active_tab)
    
    tabs_links.click (event) ->
      this_link = $(this)
      if tab_type_of(this_link) isnt 'link'
        event.preventDefault()
        this_tab = this_link.parent()
        if not this_tab.is('.active') and not this_link.is('.ajax-loading')
          this_tab_content = tabs_contents.filter "##{content_id_from this_link}"
          previous_active_tab = tabs.filter '.active'
          previous_active_tab_content = tabs_contents.filter '.active'
          activate_tab_and_content = ->
            tabs_and_contents.removeClass('active').addClass('hidden')
            this_tab.removeClass('hidden').addClass('active')
            this_tab_content.removeClass('hidden').addClass('active')
            previous_active_tab_content.trigger 'bettertabs-after-deactivate'
            this_tab_content.trigger 'bettertabs-after-activate'
            change_url this_link
          
          previous_active_tab_content.trigger 'bettertabs-before-deactivate'
          this_tab_content.trigger 'bettertabs-before-activate'
          
          if tab_type_of(this_link) is 'ajax' and not this_link.data('content-loaded-already')?
            this_link.addClass('ajax-loading')
            this_tab_content.trigger 'bettertabs-before-ajax-loading'
            this_tab_content.load this_link.attr('href'), ->
              this_link.removeClass('ajax-loading')
              this_link.data('content-loaded-already', yes)
              this_tab_content.trigger 'bettertabs-after-ajax-loading'
              activate_tab_and_content()
          else
            activate_tab_and_content()





