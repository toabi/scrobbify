# scrobbify and stuff : Tools to work around a missing API

## Overview

There's a notable lack of [AppleScript support in the Spotify player](http://getsatisfaction.com/spotify/topics/spotify_applescript_dictionary), and I (along [with many others](http://getsatisfaction.com/spotify/topics/spotify_applescript_dictionary)) would like to do interesting things with Spotify. Things like, updating my [Adium](http://adium.im/) status with what I'm listening to on Spotify, sticking what's now playing in the office on an LED message panel, and doing other interesting mashups.

So, here's a workaround, using Spotify's built-in [scrobbling](http://www.last.fm/help/faq?category=Scrobbling) feature. What I'm attempting to do, is capture the network packets that are sent from the Spotify player to Last.fm's [API](http://www.last.fm/api/intro), and extract what's now playing by inspecting the HTTP request.

Yep, it's all pretty backwards, but I think it's the only viable workaround, until either Spotify adds an AppleScript dictionary, or Last.fm provides some kind of real-time webhook interface.

## using scrobbify

1. Be sure to [enable scrobbling to last.fm](http://www.spotify.com/uk/blog/archives/2008/12/18/spotify-scrobbles/) in your Spotify player preferences.

2. In your custom scripts, use scrobbify like this:

        import scrobbify, sys
        
        def cb(now_playing, data):
            sys.stdout.write("Now playing: '%s' by '%s'.\n" % (now_playing['t'][0], now_playing['a'][0]))
            sys.stdout.flush()
            
        scrobbifier = scrobbify.Scrobbify(cb, interface='en0')
        scrobbifier.start()
        
        # Exit gracefully...
        try:
            while True:
                time.sleep(2**20)
        except (KeyboardInterrupt, SystemExit):
            scrob.stop()
            
The following meta-data is avaliable in the `now_playing` variable):

* Title  [t]
* Artist [a]
* Album  [b]
* Length [l] in seconds
* Track  [n] of the album

### OS X: Python pcap
Under OS X it's possible that easy_install will not find a version of pylibpcap. Use can install one with the help of [MacPorts](http://www.macports.org/). Attention: You have to use the python2.6 binary in `/opt/local/bin/` to be able to import `pcap` which is required by scrobbify.

## Example applications
Here are some example applications using the scrobbify library to do things™.

### Spobbilog
It's a very simple and basic example for scrobbify usage. It writes the songs you listen to in Spotify to a file (`~/.spobbilog`). The format of the file is

    timestamp; title; artist; album \n

The textfile can be used as a very simple interface to other applications. For example you can get the last played title with the following shell command:

    tail -n1 ~/.spobbilog | cut -f 2 -d ';'

Adjust the "2" to get other attributes of the last song.

### Adium Script
With Spobbilog you have a history and the currently playing song. Let's use that log for some useful stuff. Insert the last played song into a message, by starting your message with `/spotify` or `%_spotify`.
Make sure to have Spobbilog running and Last.fm posting enabled.

### update Ladiocast metadata
Similar to the Adium Script you can run the `updateLadioCast` Apple Script which reads the 
`.spobbilog` file every 15 seconds and then updates the [LadioCast](http://blog.kawauso.com/kawauso/macladiocast/) metadata. 

## Feedback
I'm fairly certain the code is sub-optimal right now, so feel free to leave me some feedback, via [email](http://scr.im/stevie) or even [twitter](http://twitter.com/steveWINton). :)

Author of the example apps: [toabi](http://twitter.com/toabi).
