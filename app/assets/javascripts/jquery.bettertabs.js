(function() {
  /*!
   jQuery Bettertabs Plugin
   version: 1.3 (Jun-2-2011)
   @requires jQuery v1.3 or later

   Examples and documentation at: https://github.com/agoragames/bettertabs

   Copyright (c) 2011 Mario Izquierdo (tothemario@gmail.com)
   Dual licensed under the MIT and GPL licenses:
     http://www.opensource.org/licenses/mit-license.php
     http://www.gnu.org/licenses/gpl.html
  */  var $, ajax_url_attr, content_id_from, show_content_id_attr, tab_type_attr, tab_type_of;
  $ = jQuery;
  tab_type_attr = 'data-tab-type';
  show_content_id_attr = 'data-show-content-id';
  ajax_url_attr = 'data-ajax-url';
  tab_type_of = function($tab_link) {
    return $tab_link.attr(tab_type_attr);
  };
  content_id_from = function($tab_link) {
    return $tab_link.attr(show_content_id_attr);
  };
  $.Bettertabs = {
    change_browser_url: function(url) {
      if ((typeof history != "undefined" && history !== null) && (history.replaceState != null)) {
        return history.replaceState(null, document.title, url);
      }
    },
    select_tab: function(bettertabs_id, tab_id) {
      return $("#" + tab_id + "_" + bettertabs_id + "_tab a").click();
    }
  };
  $.fn.bettertabs = function() {
    this.each(function() {
      var mytabs, tabs, tabs_and_contents, tabs_contents, tabs_links;
      mytabs = $(this);
      tabs = mytabs.find('ul.tabs > li');
      tabs_links = mytabs.find('ul.tabs > li > a');
      tabs_contents = mytabs.children('.content');
      tabs_and_contents = tabs.add(tabs_contents);
      return tabs_links.click(function(event) {
        var activate_tab_and_content, previous_active_tab, previous_active_tab_content, this_link, this_tab, this_tab_content;
        this_link = $(this);
        if (tab_type_of(this_link) !== 'link') {
          event.preventDefault();
          this_tab = this_link.parent();
          if (!this_tab.is('.active') && !this_link.is('.ajax-loading')) {
            this_tab_content = tabs_contents.filter("#" + (content_id_from(this_link)));
            previous_active_tab = tabs.filter('.active');
            previous_active_tab_content = tabs_contents.filter('.active');
            activate_tab_and_content = function() {
              tabs.removeClass('active');
              tabs_contents.removeClass('active').addClass('hidden');
              this_tab.addClass('active');
              this_tab_content.removeClass('hidden').addClass('active');
              previous_active_tab_content.trigger('bettertabs-after-deactivate');
              this_tab_content.trigger('bettertabs-after-activate');
              return $.Bettertabs.change_browser_url(this_link.attr('href'));
            };
            previous_active_tab_content.trigger('bettertabs-before-deactivate');
            this_tab_content.trigger('bettertabs-before-activate');
            if (tab_type_of(this_link) === 'ajax' && !(this_link.data('content-loaded-already') != null)) {
              this_link.addClass('ajax-loading');
              this_tab_content.trigger('bettertabs-before-ajax-loading');
              return this_tab_content.load(this_link.attr(ajax_url_attr), function() {
                this_link.removeClass('ajax-loading');
                this_link.data('content-loaded-already', true);
                this_tab_content.trigger('bettertabs-after-ajax-loading');
                return activate_tab_and_content();
              });
            } else {
              return activate_tab_and_content();
            }
          }
        }
      });
    });
    return this;
  };
}).call(this);
