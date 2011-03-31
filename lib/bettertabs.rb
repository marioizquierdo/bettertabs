#
# BETTERTABS
# Feature Spec:
#  * Should always work with javascript disabled (using the urls of the tabs links)
#  * The bettertabs hepler should accept:
#    * args: (bettertabs_id, options)
#    * options can be:
#       * :selected_tab => tab_id to select by default
#         * :selected_tab should be overridden with params[:"#{bettertabs_id}_selected_tab"] if present
#       * any other option is used as wrapper html_options (wrapper is the top-level widget dom element).
#  * The bettertabs helper should render clear markup:
#     * A wrapper with class 'bettertabs'
#     * Tabs markup
#        * ul.tabs > li > a  
#        * selected tab is ul.tabs > li.active > a
#        * each a element has element attributes:
#           * data-tab-type (for javascript: change click behavior depending on type "static", "link" or "ajax")
#           * data-show-content-with-id (for javascript: element id to show when select this tab)
#     * sections for each tab content.
#     * use a unique html id (based on bettertabs_id and tab_id) for each Tab and Content
#  * The bettertabs builder ".from" method should accept:
#     * args: (tab_id, tab_name, options, &block)
#     * args: (tab_id, options, &block)
#    * If block_given? the block is used as content related to this tab
#     * options can be:
#       * :partial => to use as content. Defaults to tab_id
#          * if block_given? this option can not be used (if used, raise an error)
#       * :url => for the tab link, that should go to this selected tab when javascript is disabled. Defaults to { :"#{bettertabs_id}_selected_tab" => tab_id }
#       * :tab_type => used in the markup as the link data-tab-type value. Can be :static, :link or :ajax (or the corresponding strings). Raise error otherwise. Defaults to :static.
#  * The bettertabs builder ".static", ".link" and ";ajax" methods are only a convenient way to use ".for" method with :tab_type set to :static, :link or :ajax respectively.
#  * Content is rendered only for active tab, except when tab_type is :static, where content is always rendered (ready to show when select that tab using javascript).
#
#

require 'bettertabs/bettertabs_builder'
require 'bettertabs/bettertabs_helper'

# Include bettertabs in the Application
module ApplicationHelper
  include BettertabsHelper
end
