# Allowance

**Allowance is a general-use permission management library for Ruby.
It's decidedly simple, highly flexible, and has out-of-the-box support
for ActiveModel-compliant classes.**

It was inspired by Ryan Bates' fantastic Rails authorization plugin [cancan](https://github.com/ryanb/cancan) and, unlike most other gems
of its kind, is not bound to a specific framework.

A simple Example:

``` ruby
p = Allowance.define do |can|
  # Allow logging in
  can.login!

  # Allow creating new Article instances
  can.create! Article

  # Allow the user to edit Article instances that belong to him
  can.edit! Article, :author_id => current_user.id

  # Allow viewing all Article instances that are published or the user's
  can.read! Article, ['published = ? OR author_id = ?', true, current_user.id]
end
```

Allowance parses these permission definitions and stores them in the object the
`Allowance.define` call returns. It is now up to you to query that object where
necessary. Some examples:

``` ruby
p.login?            # true
p.create? Article   # true
p.read? @article    # true or false, depending on state of @article
```

You can use the same object to provide you with correctly scoped models, too:

``` ruby
p.scoped_model(:view, Article).all
# -> Article.where(['published = ? OR author_id = ?', true, current_user.id]).all
```



## Installation

### Requirements

Allowance should work fine with Ruby 1.8.7, 1.9.2, 1.9.3 and respective JRuby versions. Please consult Allowance's [Travis status page](http://travis-ci.org/hmans/allowance) for details.

[![Build Status](https://secure.travis-ci.org/hmans/allowance.png)](http://travis-ci.org/hmans/allowance)

### Installing through Bundler

Well, you've done this before, haven't you? Just add the `allowance` gem to your project's Gemfile:

``` ruby
gem 'allowance'
```

### Installing without Bundler

Install using RubyGems:

```
gem install allowance
```

Then require it in your code:

```
require 'rubygems'
require 'allowance'
```


## Usage

### Defining permissions

Use `Allowance.define` to create a new permissions object, then use its `allow!` or `can!`
methods to add permissions:

``` ruby
p = Allowance.define
p.allow! :sing
```

Instead of using `allow!` or `can!`, you can just name the permission directly:

``` ruby
p.sing!
```

You can also specify permissions as a block:

``` ruby
p = Allowance.define do |allow|
  allow.sing!
end
```

### Querying permissions

Similar to how you define permissions, you can use the `allowed?` or `can?` methods, or
query permissions directly by name. The following two lines are equivalent:

``` ruby
p.allowed? :sing
p.can? :sing
p.sing?
```

### One-dimensional permissions

Allowance lets you define simple, one-dimenstional permissions like this:

``` ruby
p = Allowance.define do |allow|
  allow.sing!
  allow.play!
  allow.dance! if current_user.can_dance?
end
```

### Two-dimensional permissions

Most of the time, you will be using two-dimensional permissions, consisting of a
_verb_ and an _object_, with the object typically being some kind of model class.
For example:

``` ruby
p = Allowance.define do |allow|
  allow.view! Article

  if current_user.is_admin?
    allow.edit! Article
  end
end
```

When querying for permissions, just pass an object as an additional parameter:

``` ruby
p.edit? Article
```

When you pass a class instance (instead of a class), Allowance will check for
the permission defined for its class, so the following will work, too:

``` ruby
p.edit? @article
```

Allowance will even allow you to define permissions in specific objects -- this is not recommended, though, since permission objects defined through Allowance only exist in memory; if you need to control permissions on individual model objects, you'll be better off with another authorization library, ideally one that stores its permissions in your datastore.


### Defining model scopes

For classes implementing ActiveModel (eg. ActiveRecord, Mongoid and others), Allowance allows you to restrict certain permissions to specific scopes. For example, if, in  a web application, a user should only be able to see articles that have been published, but admin users can see everything, you can define the permissions like this:

``` ruby
p = Allowance.define do |allow|
  allow.view! Article, :published => true

  if current_user.is_admin?
    allow.view! Article
  end
end
```

You can see here that when a specific permission (for a _verb_ and _object_ combination) is defined more than once, the last definition will overwrite all those that came before it.

In the example above, we defined the scope as a so-called "where conditions hash", ie. a hash passed to the model class' `.where` method. Since the hash notation assumes a logical AND and isn't all that flexible overall, you can also use the same string/array syntax you know from ActiveModel:

``` ruby
p.view! Article, ['published = ? OR user_id = ?', true, current_user.id]
```

Lastly, you're encouraged to re-use scopes defined on the model class. Just define your scope using a lambda:

``` ruby
p.view! Article, lambda { |r| r.viewable_by(current_user) }
```


### Defining contextual permissions

Since permissions are just Ruby code, you can use all your favorite language
constructs when defining permissions. For example, in a web application
providing a `current_user` method, you can do the following:

``` ruby
permissions = Allowance.define do |allow|
  allow.read! Article

  if current_user.is_admin?
    allow.destroy! Article
  end
end
```

You can then query this permission like you'd expect:

``` ruby
@article = Article.find(params[:id])
if permissions.destroy? @article
  @article.destroy
else
  raise "You're not allowed to do this"
end
```

## Contributing

I'm looking forward to seeing your Pull Requests. However, please be aware that,
like with pretty much all other projects I'm maintaining, I'm trying to keep it
as small as possible, so I'm going to be somewhat picky about which pull
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
