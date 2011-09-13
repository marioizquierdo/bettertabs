Bettertabs Javascript Development
=================================

Bettertabs rails helper depends on the jquery.bettertabs plugin to work properly with javascript.


## CoffeeScript ##

The jquery.bettertabs plugin is written using CoffeeScript.
How to install CoffeeScript: http://jashkenas.github.com/coffee-script/#installation

To install, first make sure you have a working copy of the latest stable version of Node.js, and npm (the Node Package Manager).
You can then install CoffeeScript with npm:

    npm install coffee-script
    

Then you will be able to compile `jquery.bettertabs.js.coffee` into `jquery.bettertabs.js` using the coffee command:

    cd app/assets/javascripts
    coffee --print jquery.bettertabs.js.coffee > jquery.bettertabs.js


## JavaScript Compressor ##

Before make a new release of the `jquery.bettertabs.js`, we have to be sure that an equivalent minified script is available.

You can use for example the [YUI compressor](http://developer.yahoo.com/yui/compressor/), the [Google Cosure Compiler](http://code.google.com/closure/compiler/) or [JSMin](http://crockford.com/javascript/jsmin) among others..

I used a simple solution of copy-paste the `jquery.bettertabs.js` in an online tool and then copy-paste again in the `jquery.bettertabs.min.js` file.

Online compressors:

  * http://refresh-sf.com/yui/
  * http://yui.2clics.net/
  * http://closure-compiler.appspot.com/home
  * http://compressorrater.thruhere.net/