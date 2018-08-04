# Approval

[![Build Status](https://travis-ci.org/yhirano55/approval.svg?branch=master)](https://travis-ci.org/yhirano55/approval)
[![Gem Version](https://badge.fury.io/rb/approval.svg)](https://badge.fury.io/rb/approval)

:ok_woman::no_good:Approval flow for Rails

## Installation

1. Add approval to your `Gemfile`:

  ```ruby
  gem 'approval'
  ```

2. Add approval_requests, approval_comments, approval_items tables to your database and an initializer file for configuration:

  ```bash
  $ bundle exec rails generate approval:install
  ```

3. Add `acts_as_approval_user` to your user model (`User`, `AdminUser`, `Member` ...etc)::

  ```ruby
  class User < ApplicationRecord
    acts_as_approval_user
  end
  ```

4. Add `acts_as_approval_resource` to the models you want use approval flow:

  ```ruby
  class Book < ApplicationRecord
    acts_as_approval_resource
  end
  ```

  Or if you want to use PORO:

  ```ruby
  class SomeProcess
    def self.perform
      # something
    end
  end
  ```

## Approval Flow

### Make request

You send request, but resources aren't created/updated/destroyed.

#### :pray: Create

```ruby
staff = User.find_or_create_by(email: "staff@example.com")

record  = Book.new(name: "Ruby Way", price: 2980)
request = staff.request_for_create(record, reason: "something")
request.save # Created Approval::Request record.

records = 10.times.map {|n| Book.new(name: "my_book_#{n}", price: 300) }
request = staff.request_for_create(records, reason: "something")
request.save!
```

#### :pray: Update

```ruby
staff = User.find_or_create_by(email: "staff@example.com")

record  = Book.find(1).tap {|record| record.name = "new book title" }
request = staff.request_for_update(record, reason: "something")
request.save

records = Book.where(id: [1, 2, 3]).each {|record| record.price *= 0.5 }
request = staff.request_for_update(records, reason: "something")
request.save!
```

#### :pray: Destroy

```ruby
staff = User.find_or_create_by(email: "staff@example.com")

record  = Book.find(1)
request = staff.request_for_destroy(record, reason: "something")
request.save

records = Book.where(id: [1, 2, 3])
request = staff.request_for_destroy(records, reason: "something")
request.save!
```

#### :pray: Perform

```ruby
staff = User.find_or_create_by(email: "staff@example.com")

record  = MyProcess.new(recipient: "somebody@example.com")
request = staff.request_for_perform(record, reason: "something")
request.save
```

### Respond

#### :ok_woman: Approve

Then resources are created/updated/destroyed, if respond user have approved the request.

```ruby
admin = User.find_or_create_by(email: "admin@example.com")

request = Approval::Request.first
respond = admin.approve_request(request, reason: "something")
respond.save! # Create/Update/Destroy resources
```

##### :no_good: Reject

Then resources are not created/updated/destroyed, if respond user have rejected the request.

```ruby
admin = User.find_or_create_by(email: "admin@example.com")

request = Approval::Request.first
respond = admin.reject_request(request, reason: "something")
respond.save!
```

##### :wastebasket: Cancel

```ruby
staff = User.find_or_create_by(email: "staff@example.com")

request = Approval::Request.first
respond = staff.cancel_request(request, reason: "something")
respond.save!
```

### Comment

```ruby
admin = User.find_or_create_by(email: "admin@example.com")

request = Approval::Request.first
admin.approval_comments.create(request: request, content: "Hello")
```

### Configuration

```ruby
# config/initializers/approval.rb

Approval.configure do |config|
  # User Class Name (e.g: User, AdminUser, Member)
  config.user_class_name = "User"

  # Maximum characters of comment for reason (default: 2000)
  config.comment_maximum = 2000

  # Permit to respond to own request? (default: false)
  config.permit_to_respond_to_own_request = false
end
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
