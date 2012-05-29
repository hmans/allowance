# Allowance

Allowance is a general-use permission management library that can be used
in any framework or application.

A very, very simple Example:

    p = Allowance.define do |can|
      can.sing!
      can.play!
    end

    p.sing?   # true
    p.play?   # true
    p.dance?  # false

You can specify permissions on objects (and their classes), too:

    p = Allowance.define do |can|
      # Everyone can view posts that have been published
      can.view! Post, :published => true

      # Post owners can delete their own posts
      can.delete! Post, :user_id => current_user.id

      # Admin users can view and delete all posts
      if current_user.admin?
        can.view! Post
        can.delete! Post 
      end
    end

Instead of condition hashes, you can specify lambdas. This is great for model
classes that are ActiveModel based (eg. ActiveRecord, Mongoid etc.):

    p = Allowance.define do |can|
      # Everyone can view posts that have been published
      can.view! Post, lambda { |posts| posts.visible_posts }
    end

More documentation coming up soon.

## Installation

Just like with most other gems, either install and `require` the gem manually,
or add it to your Gemfile:

    gem 'allowance'

## Usage

TODO: Write usage instructions here

## Contributing

I'm looking forward to seeing your Pull Requests. However, please be aware that,
like with pretty much all other projects I'm maintaining, I'm trying to keep it
as small as possible, so I'm going to be somewhat picky about which pull
requests to accept. If you're adding new features, I recommed you check back
with me first in order to avoid disappointment.

## License

Copyright (c) 2012 Hendrik Mans

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
