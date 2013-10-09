Salem Forum Checker
============

This should work on any modern ubuntu computer. Will require modification for OSX or Windows, or a shim to make notify-send do something useful. Emailing rather than notifying coming soon!

Oh and what it does (not that that's of any importance) is check your forum account for new messages every 10 seconds and make a window manager notification when there's something new.

Setup
-----------
```
$ cd forum_checker
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
