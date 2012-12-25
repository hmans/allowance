# Allowance

**Allowance is a general-use permission management library for Ruby.
It's decidedly simple, highly flexible, and has out-of-the-box support
for ActiveModel-compliant classes.**

It was inspired by Ryan Bates' fantastic Rails authorization plugin [cancan](https://github.com/ryanb/cancan) and, unlike most other gems
of its kind, is not bound to a specific framework.

A simple Example:

``` ruby
class User < ActiveRecord::Base
  include Allowance

  def define_permissions
    # every user can read all posts
    allow :read, Post

    # users can edit/delete their own posts
    allow :manage, Post, user_id: id

    if admin?
      # admins can edit/delete all posts
      allow :manage, Post
    end
  end
end
```



## Installation

### Requirements

Allowance should work fine with Ruby 1.8.7, 1.9.2, 1.9.3 and respective JRuby versions. Please consult Allowance's [Travis status page](http://travis-ci.org/hmans/allowance) for details.

[![Build Status](https://secure.travis-ci.org/hmans/allowance.png?branch=master)](http://travis-ci.org/hmans/allowance)

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

_Coming soon._

### Querying permissions

_Coming soon._

### One-dimensional permissions

_Coming soon._

### Two-dimensional permissions

_Coming soon._


### Defining model scopes

_Coming soon._

### Defining contextual permissions

_Coming soon._

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
