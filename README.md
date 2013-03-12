[![Code Climate](https://codeclimate.com/github/kalenkov/last_line.png)](https://codeclimate.com/github/kalenkov/last_line)

# LastLine

## Last Line of CSRF Defence

Rails provides CSRF protection for your application out of the box. This protection
covers only non-GET (or HEAD) requests, as GET requests are not supposed to change any state.
Unfortunately, there are two main gaps in default CSRF prevention:

- Routing information is handled independently from controller logic. It is not trivial to trace
  which actions are allowed to process GET requests. Most common example - un-commenting generic route
  `match ':controller(/:action(/:id))(.:format)'` (hidden at the end of `routes.rb`) opens all controller
  actions to GET requests.

- Sometimes it is important to provide CSRF protection for GET requests too. Common use case for this -
  redirect from external service, like third party authentication.

LastLine is an attempt to bridge these gaps. It provides

- Whitelisting actions for GET requests on controller level

- A way to verify authenticity token for GET request

## Installation

Include in your Gemfile

    gem 'last_line'

and run

    bundle install

## Usage

### Whitelisting GET actions
To require GET request whitelisting for the whole application, insert `protect_from_gets` in your
`ApplicationController` after `protect_from_forgery`:

    class ApplicationController < ActionController::Base
      protect_from_forgery
      protect_from_gets
      [...]
    end

In case you want to whitelist GETs in a particular controller only, insert the same line in your controller
instead of `ApplicationController` (not recommended)

If you want to whitelist GET actions in your application, but exclude some controller from whitelisting
(not recommended):

    class MySafeController < ApplicationController
      allow_gets :all
    end

The best (easiest to trace) way to whitelist a particular action is to add `allow_get :action` after its definition:

    def index
      [...]
    end
    allow_get :index

Alternatively you can whitelist all actions in the same place. For this include in your controller

    allow_gets :only => [:action1, :action2]

There is also a simple way to do blacklisting instead of whitelisting (not recommended, as it is much less reliable):

    allow_gets :except => [:action1, :action2]

### CSRF protection for GET actions

You can protect specific action from CSRF by specifying it as a `protected_get`. Such protection will automatically
whitelist corresponding action for GET requests.

    def redirected
      [...]
    end
    protected_get :redirected

When this action is called without `form_authenticity_token` as explicit parameter or in the header,
`handle_unverified_request` will be called (default Rails behavior is to clear session data)

You can add token as a parameter to your get request providing it explicitly

    <%= link_to 'Protected get', some_defined_path(request_forgery_protection_token => form_authenticity_token) %>

Please be aware that `protected_get` adds its filter on top of filter chain to avoid potential side effects
of other filters. It means that none of subsequent filters that rely on session data will work if request is
not verified

