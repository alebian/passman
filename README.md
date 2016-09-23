# PassMan - Password Manager
[![Gem Version](https://badge.fury.io/rb/passman.svg)](https://badge.fury.io/rb/passman)
[![Dependency Status](https://gemnasium.com/badges/github.com/alebian/passman.svg)](https://gemnasium.com/github.com/alebian/passman)
[![Build Status](https://travis-ci.org/alebian/passman.svg)](https://travis-ci.org/alebian/passman)
[![Code Climate](https://codeclimate.com/github/alebian/passman/badges/gpa.svg)](https://codeclimate.com/github/alebian/passman)
[![Test Coverage](https://codeclimate.com/github/alebian/passman/badges/coverage.svg)](https://codeclimate.com/github/alebian/passman/coverage)
[![Inline docs](http://inch-ci.org/github/alebian/passman.svg)](http://inch-ci.org/github/alebian/passman)

PassMan is a command line application that stores your passwords encrypted with AES 256 symmetric-key algorithm. It also let's you save more information about your accounts such as recovery information and more.

## Installation

Run this in your terminal:

    $ gem install passman

## Usage

### CLI

The easiest way to use PassMan is using it's command line interface, run:

```
$ passman-cli
```

![PassMan](https://raw.githubusercontent.com/alebian/passman/master/passman-cli.png)

### Commands

PassMan will save your passwords in a file called 'passman.json' by default, you can tell PassMan to store  the passwords in different files.

First of all you will need a 32 bit (or more) symmetric key. This will be used in the future to encrypt and decrypt your passwords but PassMan will not store that value. Everytime PassMan needs to encrypt or decrypt your passwords it will ask you for one key. You can tell PassMan to create a new secure random key if you want to:

```
$ passman -g 32
#=> c50647a4dde91848fb5edda217149258
```

Once you have your key, write it down on paper or try to remember it. Now you can start saving your passwords.

```
$ passman -a Twitter -u alebian -p MySuperPassword
```

You will be prompted to insert you key and then PassMan will store your password.

Now you can retreive your passwords:

```
$ passman -r Twitter
```

You can tell Passman to store your password in a different file:

```
$ passman -a Twitter -u alebian -p MySuperPassword -f ~/my_database
```

You can list the stored accounts:

```
$ passman -l
```

You can delete your accounts:

```
$ passman -d Twitter
```

For any password generated, you can combine the parameter -c to copy it in your clipboard, this way it won't be stored in your terminal history.

```
$ passman -g -c
#=> Password copied to clipboard!
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Run rubocop lint (`rubocop -R --format simple`)
5. Run rspec tests (`bundle exec rspec`)
6. Push your branch (`git push origin my-new-feature`)
7. Create a new Pull Request
