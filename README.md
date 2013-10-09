Salem Forum Checker
============

This should work on any modern ubuntu computer. Will require modification for OSX or Windows, simplest thing would just be to remove the calls to notify-send and you'll still get the email.

Oh and what it does (not that that's of any importance) is check your forum account for new messages every 10 seconds and make a window manager notification and email you when there's any new messages since last it checked.

Setup
-----------
```
$ git clone https://github.com/jcwilk/salem_forum_checker.git
$ cd salem_forum_checker
$ bundle
$ cp ./credentials.yml.example ./credentials.yml
$ vim ./credentials.yml
```

Running it
-----------
```
$ ruby ./forum_checker.rb
```

Example output
-----------
```
$ ruby ./forum_checker.rb
logging in as "jcwilk"...
fetching messages...
0
fetching messages...
0
fetching messages...
```

Contributing
-----------
Go for it! :D Please do it via pull request though, but how else would you?
