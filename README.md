> 👋 Our Rails example has moved to a new home within our SDK repository. Check it out [here](https://github.com/readmeio/metrics-sdks/tree/main/packages/ruby/examples/metrics-rails).

# ReadMe Ruby SDK - Sample Rails Application

This repository contains a sample Rails application that shows how to configure
the ReadMe Ruby gem.

## Dependencies and Requirements

* Rails 6.0.2.3
* Ruby 2.7
* PostgreSQL

You'll also need an account for the [ReadMe Dashboard](dash.readme.com) to create a project and obtain an
API key.

## Setup

Clone the repo and in the root directory run:

```
cp .env.sample .env
```

Edit the .env file to include the API key obtained from your projects
dashboard. Then you can run:

```
bundle && rails db:setup
```

## Run the application

Once everything is installed and setup you can run the application with:

```
rails s
```

By default this will run at `localhost:3000`

## Fetching user info

This sample application uses devise and simple_token_authentication for
token-based auth. To fetch the current user when create requests for the Readme
API, user data is fetched from the WardenProxy contained in the env.

You'll need to provide a return value for the case where no user is logged in.

```ruby
  # config/environments/development.rb or config/environments/production.rb

  config.middleware.use Readme::Metrics, options do |env|
    current_user = env['warden'].authenticate

    if current_user.present?
      {
        id: current_user.id,
        label: current_user.name,
        email: current_user.email
      }
    else
      {
        id: "Sample Rails Application",
        label: "Guest",
        email: "guest@example.com"
      }
    end
  end
```

## Authentication Endpoints

### Sign Up

To start with, sign up to create a user and obtain an `authentication_token`

`POST http://localhost:3000/users`

```JSON
{
  "user": {
    "email": "user@example.com",
    "password": "password",
    "name": "Your Name"
  }
}
```

#### Response

```JSON
{
  "id": 3,
  "name": "Your Name",
  "email": "user@example.com",
  "created_at": "2020-08-26T20:34:29.338Z",
  "updated_at": "2020-08-26T20:34:29.338Z",
  "authentication_token": "z-tweAX_3xDDmoHzobRY"
}
```

### Sign In

You may also sign in as an existing user

`POST http://localhost:3000/users/sign_in`

```JSON
{
  "user": {
    "email": "user@example.com",
    "password": "password"
  }
}
```

#### Response

```JSON
{
  "id": 3,
  "name": "Your Name",
  "email": "user@example.com",
  "created_at": "2020-08-26T20:34:29.338Z",
  "updated_at": "2020-08-26T20:34:29.338Z",
  "authentication_token": "z-tweAX_3xDDmoHzobRY"
}
```

### Sign Out

The sign out endpoint requires no body and returns a 204 on success

`DELETE http://localhost:3000/users/sign_out`

## Post endpoints

All of the following endpoints **except the posts list** require the following
authentication headers:

```
X-User-Email=user@example.com;
X-User-Token=z-tweAX_3xDDmoHzobRY;
```

### List all posts

`GET http://localhost:3000/posts`

#### Response

```JSON
[
  {
    "id": 4,
    "user_id": 1,
    "title": "A really cool post",
    "body": "Some body text for this excellent post",
    "created_at": "2020-08-26T19:01:10.199Z",
    "updated_at": "2020-08-26T19:01:10.199Z"
  },
  {
    "id": 5,
    "user_id": 2,
    "title": "Another really cool post",
    "body": "Some body text for this excellent post",
    "created_at": "2020-08-26T19:01:10.199Z",
    "updated_at": "2020-08-26T19:01:10.199Z"
  }
]
```

### Create a post

*Requires authentication headers*

`POST http://localhost:3000/posts`

```JSON
{
  "post": {
    "title": "A really cool post",
    "body": "Some body text for this excellent post"
  }
}
```

#### Response

```JSON
{
  "id": 4,
  "user_id": 1,
  "title": "A really cool post",
  "body": "Some body text for this excellent post",
  "created_at": "2020-08-26T19:01:10.199Z",
  "updated_at": "2020-08-26T19:01:10.199Z"
}
```

### Update a post

*Requires authentication headers*

`PATCH http://localhost:3000/posts/:post_id`

```JSON
{
  "post": {
    "title": "A really cool post",
    "body": "Some body text for this excellent post"
  }
}
```

#### Response

```JSON
{
  "id": 4,
  "user_id": 1,
  "title": "A really cool post",
  "body": "Some body text for this excellent post",
  "created_at": "2020-08-26T19:01:10.199Z",
  "updated_at": "2020-08-26T19:01:10.199Z"
}
```

### Delete a post

*Requires authentication headers*

Requires no body and returns a 200 on success.

`DELETE http://localhost:3000/posts/:post_id`
