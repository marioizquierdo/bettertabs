###!
 jQuery Bettertabs Plugin
 version: 1.4 (Mar-12-2012)
 @requires jQuery v1.3 or later

 Examples and documentation at: https://github.com/agoragames/bettertabs

 Copyright (c) 2011 Mario Izquierdo (tothemario@gmail.com)
 Dual licensed under the MIT and GPL licenses:
   http://www.opensource.org/licenses/mit-license.php
   http://www.gnu.org/licenses/gpl.html
###

$ = jQuery

tab_type_attr = 'data-tab-type' # attribute on tab links that indicate the tab type
tab_initial_via_attr = 'data-tab-initial-via' # attribute on tab links that indicate the tab type
show_content_id_attr = 'data-show-content-id' # attribute on tab links that indicate the related content id
ajax_url_attr = 'data-ajax-url' # attribute on ajax tab liks with the ajax href
append_attr = 'data-append' # attribute on tab links with the content to append
show_append_id_attr = 'data-show-append-id' # attribute on tab links with the append container id
tab_type_of = ($tab_link) -> $tab_link.attr(tab_type_attr)
tab_initial_via = ($tab_link) -> $tab_link.attr(tab_initial_via_attr)
content_id_from = ($tab_link) -> $tab_link.attr(show_content_id_attr)
append_id_from = ($tab_link) -> $tab_link.attr(show_append_id_attr)

# jQuery.Bettertabs API
$.Bettertabs =
  # jQuery.Bettertabs.change_browser_url(url) => Replace the browser history state with this new url
  change_browser_url: (url) ->
    # Use replaceState for HTML5 browsers, and just ignore for old browsers (no change url support).
    # This will work on last modern browsers, but I could not find an easy way to listen the popstate event,
    # so better not to use pushState (because we can't safely revert to previous state), replaceState just works fine.
    if history? and history.replaceState?
      history.replaceState null, document.title, url

  # jQuery.Bettertabs.select_tab(bettertabs_id, tab_id) => click on the tab_id link of the bettertabs_id widget
  select_tab: (bettertabs_id, tab_id) ->
    $("##{tab_id}_#{bettertabs_id}_tab a").click()

$.fn.bettertabs = ->
  @each ->
    wrapper = $(this)
    tabs = wrapper.find 'ul.tabs > li'
    tabs_links = wrapper.find 'ul.tabs > li > a'
    tabs_contents = wrapper.children '.content:not(.content-only-block)'
    tabs_and_contents = tabs.add tabs_contents
    active_tab_link = tabs_links.filter '.active'

    if tab_type_of(active_tab_link) is 'ajax'
      unless tab_initial_via(active_tab_link) is 'ajax'
        # When tab-type is ajax, mark the first active link as content-loaded-already to not be loaded again when click later
        active_tab_link.data('content-loaded-already', yes)
      else
        active_tab_link.parent().removeClass('active')
        $ ->
          active_tab_link.click()

    tabs_links.click (event) ->
      this_link = $(this)
      unless tab_type_of(this_link) is 'link'
        event.preventDefault()
        this_tab = this_link.parent()
        if not this_tab.hasClass('active') and not this_link.hasClass('ajax-loading')
          this_tab_content = tabs_contents.filter "##{content_id_from this_link}"
          previous_active_tab = tabs.filter '.active'
          previous_active_tab_content = tabs_contents.filter '.active'
          activate_tab_and_content = ->
            tabs.removeClass('active')
            tabs_links.removeClass('active')
            tabs_contents.removeClass('active').addClass('hidden')
            if this_link.attr(append_attr) and not this_tab_content.children("##{append_id_from this_link}").length > 0
              this_tab_content.append("<div id='#{append_id_from this_link}'></div>")
              $("##{append_id_from this_link}").html($('<div/>').html(this_link.attr(append_attr)).text())
            this_tab.addClass('active')
            this_link.addClass('active')
            this_tab_content.removeClass('hidden').addClass('active')
            previous_active_tab_content.trigger 'bettertabs-after-deactivate'
            this_tab_content.trigger 'bettertabs-after-activate'
            $.Bettertabs.change_browser_url this_link.attr('href')

          previous_active_tab_content.trigger 'bettertabs-before-deactivate'
          this_tab_content.trigger 'bettertabs-before-activate'

          if tab_type_of(this_link) is 'ajax' and not this_link.data('content-loaded-already')?
            this_link.addClass('ajax-loading')
            this_tab_content.trigger 'bettertabs-before-ajax-loading'
            this_tab_content.load this_link.attr(ajax_url_attr), (responseText, textStatus, XMLHttpRequest) ->
              if textStatus is 'error' and not tab_initial_via(this_link) is 'ajax'
                window.location = this_link.attr('href')
              else
                if textStatus is 'error' and tab_initial_via(this_link) is 'ajax'
                  this_tab_content.html $(responseText).not('style').not('title').not('meta').not('script')
                this_link.removeClass('ajax-loading')
                this_link.data('content-loaded-already', yes)
                this_tab_content.trigger 'bettertabs-after-ajax-loading'
                activate_tab_and_content()
          else
            activate_tab_and_content()
  return this




