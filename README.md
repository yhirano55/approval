# Approval

[![Build Status](https://travis-ci.org/yhirano55/approval.svg?branch=master)](https://travis-ci.org/yhirano55/approval)
[![Gem Version](https://badge.fury.io/rb/approval.svg)](https://badge.fury.io/rb/approval)

:ok_woman::no_good:Approval workflow for Rails

## Installation

```ruby
gem 'approval'
```

Optionally, you can run the generator, which will set up approval models with some useful defaults for you:

```bash
$ bin/rails g approval:install
```

## Usage

### Prepare

Call `acts_as_approval_user` in your resource of user model (`User`, `AdminUser`, `Member` etc):

```ruby
class User < ApplicationRecord
  acts_as_approval_user
end
```

Call `acts_as_approval_resource` in your resource:

```ruby
class Book < ApplicationRecord
  acts_as_approval_resource
end
```

### Request

```ruby
staff   = User.find_or_create_by(email: "staff@example.com")
book    = 10.times.map { |n| Book.new(name: "my_book_#{n}") }
request = staff.request_for_create(records, reason: "something")
request.save!
```

You send request, but resources aren't created.

### Respond

```ruby
admin   = User.find_or_create_by(email: "admin@example.com")
request = Approval::Request.first
respond = admin.approve_request(request, reason: "something")
respond.save!
```

Then resources are created, if respond user have approved the request.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
