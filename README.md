# ASKME

## About
This app is Q&A network and clone of [ask.fm](https://ask.fm/)

## Version

```
$ rails -v
> Rails 6.1.4.1

$ ruby -v
> ruby 2.7.3
```

## Install
Run install gems

```
$ bundle install
```

Run install nodejs dependent
```
$ yarn install
```

Create database and run database migrations
```
$ rails db:create db:migrate
```

For work [reCAPTCHA](https://www.google.com/recaptcha/admin) must write keys in credentials:
```
recaptcha:
  public_key: <YOUR PUBLIC KEY>
  private_key: <YOUR PRIVATE KEY>
```

Start server
```
$ rails s
```

## Demo

deploy on [**VPS**](https://askme.vladfdv.ru)
