# Allowance

Allowance is a general-use permission management library that can be used
in any framework or application.

A simple Example:

~~~ ruby
p = Allowance.define do |can|
  can.sing!
  can.play!
end

p.sing?   # true
p.play?   # true
p.dance?  # false
~~~

You can specify permissions on objects (and their classes), too:

~~~ ruby
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
~~~

Instead of condition hashes, you can specify lambdas. This is great for model
classes that are ActiveModel based (eg. ActiveRecord, Mongoid etc.):

~~~ ruby
p = Allowance.define do |can|
  # Everyone can view posts that have been published
  can.view! Post, lambda { |posts| posts.visible_posts }
end
~~~

More documentation coming up soon.

## Installation

Add this line to your application's Gemfile:

    gem 'allowance'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install allowance

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
