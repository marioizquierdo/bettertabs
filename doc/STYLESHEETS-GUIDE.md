Bettertabs CSS guidelines
=========================

Bettertabs provides a rails helper and a jQuery plugin. Styles are so different between projects and can not be abstracted into a common purpose CSS stylesheet.

The best way to style up this is watching at the generated markup and style it according to your application styles.

The following bettertabs declaration (haml):

    = bettertabs :profile_tabs do |tab|
      = tab.static :general do
        General info of this profile
        
      = tab.ajax :friends, "Dudes" do
        Friends (loaded using AJAX)
       
will expand in the following markup (html):

    <div id="profile_tabs" data-initial-active-tab-id="profile_tabs_general_tab" class="bettertabs">
      <ul class="tabs">
        <li id="profile_tabs_general_tab" class="active">
          <a class="active" data-tab-type="static" data-show-content-id="profile_tabs" href="/profile/dude/general">General</a>
        </li>
        <li id="profile_tabs_friends_tab">
          <a data-tab-type="ajax" data-show-content-id="profile_tabs" href="/competition/ladder/1234/rules">RULES</a>
        </li>
      </ul>
      
      <div id="profile_tabs_general_content" class="content active">
        General info of this profile
      </div>
      
      <div id="profile_tabs_friends_content" class="content hidden">
      </div>
    </div>
    
So you can use this structure to access any bettertabs widget element (CSS):

    div.bettertabs { /* Wrapper DIV (Note: this is the default class, but it can be modified in the helper html_options) */ }

    div.bettertabs ul.tabs { /* tabs list */ }
    div.bettertabs ul.tabs li { /* tab item */ }
    div.bettertabs ul.tabs li.active { /* selected tab item */ }
    div.bettertabs ul.tabs li.active a  { /* selected tab link */ }
    div.bettertabs ul.tabs li a.active  { /* selected tab link */ }
    div.bettertabs ul.tabs li a:link,
    div.bettertabs ul.tabs li a:visited { /* tab link normal state */ }
    div.bettertabs ul.tabs li a:hover {  }
    div.bettertabs ul.tabs li a:active {  }
    div.bettertabs ul.tabs li a.ajax-loading { /* tab link while ajax content is loading */ }

    div.bettertabs div.content { }
    div.bettertabs div.content.hidden { /* hidden content. Here you should set the property display: none; */ } 
    div.bettertabs div.content.active { /* active content */ }
    
Here you are a sample of CSS you can use as example to style up your bettertabs widget:
    
    div.bettertabs { margin: 1em; width: 500px; }

    div.bettertabs ul.tabs { margin: 0; padding: 0; position: relative; }
    div.bettertabs ul.tabs li { 
      background-color: #ccc;
      border: 1px solid #999;
      display: inline; float: left; height: 24px; line-height: 24px;
      list-style: none outside none; 
      margin-right: .5em; padding-right: .5em; padding-left: .5em; 
      position: relative; top: 1px;
    }
    div.bettertabs ul.tabs li.active { height: 25px; background-color: #eee; border-bottom: none; }
    div.bettertabs ul.tabs li.active a.active  { color: black; }

    div.bettertabs ul.tabs li a { font-size: 80%; text-decoration: none; float: left; }
    div.bettertabs ul.tabs li a:link,
    div.bettertabs ul.tabs li a:visited { color: #444; }
    div.bettertabs ul.tabs li a:hover { color: #000; }
    div.bettertabs ul.tabs li a:active { color: #933; }
    div.bettertabs ul.tabs li a.ajax-loading { color: #666; }

    div.bettertabs div.content { padding: 1em; border: 1px solid #999; background-color: #eee; clear: left; }
    div.bettertabs div.content.hidden { display: none; }


And this is the same example but written in SASS:

    div.bettertabs
      margin: 1em
      width: 500px

      ul.tabs
        margin: 0
        padding: 0
        position: relative
      
        li
          background-color: #ccc
          border: 1px solid #999
          display: inline
          float: left
          height: 24px
          line-height: 24px
          list-style: none outside none
          margin-right: .5em
          padding-right: .5em
          padding-left: .5em
          position: relative
          top: 1px
      
          &.active
            height: 25px
            background-color: #eee
            border-bottom: none
          
          a
            font-size: 80%
            text-decoration: none
            float: left
            &.active
             color: black
            &:link, &:visited
              color: #444
            &:hover
              color: #000
            &:active
              color: #933
            &.ajax-loading
              color: #666

      div.content
        padding: 1em
        border: 1px solid #999
        background-color: #eee
        clear: left
      
        &.hidden
          display: none

