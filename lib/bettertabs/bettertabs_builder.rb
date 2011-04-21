class BettertabsBuilder
  
  TAB_TYPE_STATIC = :static
  TAB_TYPE_LINK = :link
  TAB_TYPE_AJAX = :ajax
  TAB_TYPES = [TAB_TYPE_STATIC, TAB_TYPE_LINK, TAB_TYPE_AJAX]
  
  def initialize(bettertabs_id, template, selected_tab_id = nil, options = {})
    @bettertabs_id = bettertabs_id
    @template = template
    @selected_tab_id = selected_tab_id
    @render_only_active_content = options.delete(:render_only_active_content) # used in ajax calls
    @wrapper_html_options = options
    
    @tabs = []
    @contents = []
  end
  
  # Static tabs generator
  def static(tab_id, *args, &block)
    get_options(args)[:tab_type] = TAB_TYPE_STATIC
    self.for(tab_id, *args, &block)
  end
  
  # Linked tabs generator
  def link(tab_id, *args, &block)
    get_options(args)[:tab_type] = TAB_TYPE_LINK
    self.for(tab_id, *args, &block)
  end
  
  # Ajax tabs generator
  def ajax(tab_id, *args, &block)
    get_options(args)[:tab_type] = TAB_TYPE_AJAX
    self.for(tab_id, *args, &block)
  end
  
  # Generic tab and content generator
  def for(tab_id, *args, &block)
    # Initialize vars and options
    options = get_options(args)
    tab_id = tab_id.to_s
    tab_text = get_tab_text(tab_id, args)
    raise "Bettertabs: #{tab_html_id_for(tab_id)} error. Used :partial option and a block of content at the same time." if block_given? and options[:partial]
    partial = options.delete(:partial) || tab_id.to_s unless block_given?
    url = options.delete(:url) || { :"#{@bettertabs_id}_selected_tab" => tab_id }
    tab_type = (options.delete(:tab_type) || TAB_TYPE_STATIC).to_sym
    raise "Bettertabs: #{tab_type.inspect} tab type not supported. Use one of #{TAB_TYPES.inspect} instead." unless TAB_TYPES.include?(tab_type)
    @selected_tab_id ||= tab_id # defaults to first tab
    
    if @render_only_active_content
      if active?(tab_id)
        @only_active_content = block_given? ? @template.capture(&block) : @template.render(:partial => partial)
      end
    else
      # Tabs
      tab_html_options = options # any other option will be used as tab html_option
      @tabs << { tab_id: tab_id, text: tab_text, url: url, html_options: tab_html_options, tab_type: tab_type, active: active?(tab_id) }
    
      # Content
      content_html_options = { id: content_html_id_for(tab_id), class: "content #{active?(tab_id) ? 'active' : 'hidden'}" }
      if active?(tab_id) or tab_type == TAB_TYPE_STATIC # Only render content for selected tab (static content is always rendered).
        content = block_given? ? @template.capture(&block) : @template.render(:partial => partial)
      else
        content = ''
      end
      @contents << { tab_id: tab_id, tab_text: tab_text, content: content, html_options: content_html_options, tab_type: tab_type, active: active?(tab_id) }
    end
    nil
  end
  
  # Renders the bettertabs markup.
  # The following instance variables are available:
  # * @tabs: list of tabs. Each one is a hash with the followin keys:
  #   * :tab_id => symbol identifier of the tab
  #   * :text => text to show in the rendered tab
  #   * :url => string with the tab url
  #   * :html_options => for use in the tab markup (included 'data-tab-type').
  #   * :tab_type => One of TAB_TYPES
  #   * :active => true if this is the selected tab
  # * @contents: list of contents asociated with each tab. Each one is a hash with the following keys:
  #   * :tab_id => symbol identifier of the tab
  #   * :tab_text => text that is used in the corresponding tab
  #   * :content => string with the content inside
  #   * :html_options => for use in the container markup
  #   * :tab_type => One of TAB_TYPES
  #   * :active => true if this is the selected content
  # * @selected_tab_id: String with the selected tab id (to match against each tab[:tab_id])
  # * @wrapper_html_options: hash with the html options used in the bettertabs container
  # * @bettertabs_id: id of the bettertabs widget
  def render
    if @render_only_active_content
      @only_active_content.html_safe
    else
    
      # Wrapper
      @wrapper_html_options ||= {}
      @wrapper_html_options[:"data-initial-active-tab-id"] = @selected_tab_id
      tag(:div, @wrapper_html_options) do
      
        # Tabs list
         tag(:ul, class: 'tabs') do
           @tabs.map do |tab|
             tag(:li, class: ('active' if tab[:active]), id: tab_html_id_for(tab[:tab_id])) do
               tab[:html_options][:"data-tab-type"] ||= tab[:tab_type] # for javascript: change click behavior depending on type :static, :link or :ajax
               tab[:html_options][:"data-show-content-id"] ||= content_html_id_for(tab[:tab_id]) # for javascript: element id to show when select this tab
               @template.link_to(tab[:text], tab[:url], tab[:html_options])
             end
           end.join.html_safe
         end +
       
         # Content sections
         @contents.map do |content|
           tag(:div, content[:html_options]) do
             content[:content] # this should be blank unless content[:active] or content[:tab_type] == :static
           end
         end.join.html_safe
      end.html_safe +
      jquery_tag("$('##{@bettertabs_id}').bettertabs();")
      
    end
  end
  
  
  private
  
  # Alias of @template.content_tag
  def tag(name, content_or_options_with_block = nil, options = nil, escape = true, &block)
    @template.content_tag(name, content_or_options_with_block, options, escape, &block)
  end
  
  # Wraps javascript code inside a javascript_tag using the jQuery(function($){ ... }); on init call.
  def jquery_tag(jquery_code)
    @template.javascript_tag("jQuery(function($){ #{ jquery_code } });")
  end
  
  # Get the options hash from an array of args. If options are not present, create them and initialize to {}
  def get_options(args)
    args << {} unless args.last.is_a?(Hash)
    args.last
  end
  
  # Get the default name of the tab, from the args list.
  def get_tab_text(tab_id, args)
    String === args.first ? args.first : tab_id.to_s.titleize
  end
  
  # Check if this tab_id is the same as @selected_tab_id
  def active?(tab_id)
    @selected_tab_id.to_s == tab_id.to_s
  end
  
  # Tab html id
  def tab_html_id_for(tab_id)
    "#{tab_id}_#{@bettertabs_id}_tab"
  end
  
  # Content html id
  def content_html_id_for(tab_id)
    "#{tab_id}_#{@bettertabs_id}_content"
  end
  
end