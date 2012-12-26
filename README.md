# Allowance

**Allowance is a general-use permission management library for Ruby.
It's decidedly simple, highly flexible, and has out-of-the-box support
for ActiveRecord models.**

It was inspired by Ryan Bates' fantastic Rails authorization plugin [CanCan](https://github.com/ryanb/cancan).

* Works great in any Ruby project, not just Rails.
* It loves ActiveRecord scopes.
* Very little code (under 100 lines).

A simple example:

~~~ ruby
class User < ActiveRecord::Base
  include Allowance::Subject

  def define_permissions
    # every user can see all other users
    allow :read, User

    # every user can see all published posts
    allow :read, Post, Post.published

    # users can edit/delete their own posts
    allow :manage, Post, user_id: id

    if admin?
      # admins can edit/delete all posts
      allow :manage, Post
    end
  end
end
~~~



## Installation

Simply add `allowance` to your project's `Gemfile` or install it through `gem install allowance`.

It should work fine with Ruby 1.9.2, 1.9.3 and respective JRuby versions. Please consult Allowance's [Travis status page](http://travis-ci.org/hmans/allowance) for details.

[![Build Status](https://secure.travis-ci.org/hmans/allowance.png?branch=master)](http://travis-ci.org/hmans/allowance)


## Usage

### Defining permissions

Allowance generally thinks in terms of "subject", "verb" and, optionally, "object". For example, a _user_ (the subject) may be allowed to _edit_ (the verb) a _post_ (the object). The object may be optional; for example, a _user_ may be able to _login_, and so on.

So, first of all, your application will need a subject. A subject can be any class that's using the `Allowance::Subject` mixin. In most applications, this will be your `User` class:

~~~ ruby
class User
  include Allowance::Subject
end
~~~

Instances of this class can now be configured with permissions using the `#allow` method:

~~~ ruby
@user.allow :read, Post
@user.allow :manage, Post, user_id: @user.id
~~~

These permissions can be queried using the `#allowed?` method:

~~~ ruby
if @user.allowed?(:destroy, @post)
  @post.destroy
end
~~~

Since you'll usually want permissions to be defined automatically when a subject instance is created, you can simply add a `#define_permissions` method that will get executed automatically:

~~~ ruby
class User
  include Allowance::Subject

  def define_permissions
    allow :read, Post
    allow :manage, Post, user_id: id
  end
end
~~~


### Using Allowance with Rails

Most of you will be using Allowance within a Rails application. Allowance gives you a lot of flexibility as to how to plug it into your app, but the most straight forward way goes as follows.

First of all, add the `Allowance::Subject` mixin to your `User` class and create a `define_permissions` method:

~~~ ruby
class User < ActiveRecord::Base
  include Allowance::Subject

  def define_permissions
    allow :read, Post
    allow :manage, Post, user_id: id
  end
end
~~~

Now, assuming your application has a `current_user` controller and helper method, you can use `current_user.allowed?` to query the currently logged in user's permissions. The code for this could look like this:

~~~ ruby
class ApplicationController < ActionController::Base
  # Set up the current user. In this example, if a currently logged in
  # user could not be found, we're creating (but not saving) a new
  # instance representing a "guest" user.
  # 
  def current_user
    @current_user ||= load_current_user || User.new
  end

  # Make it available to your views, too.
  #
  helper_method :current_user

  # Load the currently logged in user. This is just one of the many
  # ways of doing it, so this may look different in your app.
  #
  def load_current_user
    User.find(session[:current_user_id]) if session[:current_user_id]
  end
end
~~~  

All this is just a suggestion -- there are many ways of setting this up. If you're used to how CanCan does it, you could set up a separate, abstract permissions class using the `Allowance::Subject` mixin, create an instance in a `before_filter` and use that instead.


### Working with ActiveRecord scopes

When defining permissions on ActiveRecord models, you can provide an optional scope as a third parameter, either as a hash of conditions, a lambda, or an actual ActiveRecord scope. Here's a couple of examples:

~~~ ruby
# Can read all posts
allow :read, Post

# Can only read posts I've created
allow :read, Post, user_id: self.id

# Can only read published posts
allow :read, Post, Post.published

# You can also provide strings...
allow :read, Post, "published_at IS NOT NULL"

# ...or lambdas:
allow :read, Post, ->(p) { p.where("published_at < ?", 2.weeks.ago) }
~~~

When checking permissions against a model instance, Allowance will check if it's part of the allowed scope:

~~~ ruby
# This will look up whatever scope is permitted for :read actions
# on Post and will check whether the provided instance is inside
# that scope (by running `scope.exists?(instance)`).

allowed?(:read, @post)
~~~

In addition to that, the subject provides a method called `#allowed_scope` that returns the scope that is allowed for a certain verb and class:

~~~ ruby
@posts = current_user.allowed_scope(Post, :read)
~~~

Allowance also add a similar class method to your ActiveRecord classes, so the following will work, too:

~~~ ruby
@posts = Post.accessible_by(current_user, :read)
~~~

This becomes handy in Rails controllers:

~~~ ruby
class PostsController < ApplicationController
  def index
    @posts = Post.accessible_by(current_user, :index).all
    respond_with @posts
  end

  def show
    @post = Post.accessible_by(current_user, :show).find(params[:id])
    respond_with @post
  end

  # ...and so on.
end
~~~


### Verb expansion

Just like its big role model CanCan, Allowance automatically expands the `create`, `read`, `update` and `manage` verbs to include the common RESTful Rails controller action names:

* `create` is expanded into `create` and `new`
* `read` is expanded into `read`, `index` and `show`
* `update` is expanded into `update` and `edit`
* `manage` is expanded into `manage`, `index`, `show`, `new`, `create`, `edit`, `update` and `destroy`


## Contributing

I'm looking forward to seeing your Pull Requests. However, please be aware that,
like with pretty much all other projects I'm maintaining, I'm trying to keep it
as sharp and small as possible, so I'm going to be somewhat picky about which pull
requests to accept. If you're adding new features, I recommed you check back
with me first in order to avoid disappointment.

## License

Copyright (c) 2012 Hendrik Mans <hendrik@mans.de>

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
