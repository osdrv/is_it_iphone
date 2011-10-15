= is_it_iphone
* http://rubyforge.org/projects/isitiphone/

== AUTHOR:

Damon Danieli (damondanieli@gmail.com)

== FEATURES/PROBLEMS:

* Fast & Lightweight
* Simple: I'm not smart enough to make something complex

== DESCRIPTION:

This gem was inspired by the IsItMobile gem done by Dave Myron.  

The code to check for the iPhone user agent is from http://developer.apple.com.  This doesn't have any dependencies.

- in app/controllers/application.rb

    require 'is_it_iphone'
    class ApplicationController < ActionController::Base
      include IsItIPhone
      before_filter :adjust_format_for_iphone # Always show iPhone views
    end

You will have these functions:

    iphone_user_agent?
      Returns true if the user agent is an iPhone.
      (as spec'ed on http://developer.apple.com)

    iphone_request?
      Returns true if the request came from an iPhone.
      Override being an iPhone with ?format=xxxx in the URL.

    adjust_format_for_iphone
      Call when you want to show iPhone views to iPhone users.
      Note: It is recommended by Apple that you default to showing 
      your "normal" html page to iPhone users and allow them to 
      choose if they want an iPhone version.

With Rails 2.0, you can use its multiview capabilities by simply adding this to your app:

- in config/initializers/mime_types.rb

    Mime::Type.register_alias "text/html", :iphone

Then, just create your views using suffices of iphone.erb instead of html.erb:

    index.iphone.erb
    show.iphone.erb
    etc.

Note: you will probably want to use a Web library specific for iPhone applications.  FWIW, I use Dashcode (in the iPhone SDK) to write and debug the iPhone application and then integrate it with my Rails project.

== REQUIREMENTS:

None

== INSTALL:

sudo gem install is_it_iphone

== LICENSE:

Copyright (c) 2008

MIT Licence

