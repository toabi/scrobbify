import os, sys, time
import scrobbify

if __name__ == "__main__":
    def cb(now_playing, data):
        f = open(os.path.expanduser("~/.spobbilog"),'a')
        f.write("%s;%s;%s;%s\n" % (time.time(), now_playing['t'][0], now_playing['a'][0], now_playing['b'][0]))
        f.flush()
        f.close()
    sys.stdout.write("logging scrobbled spotify tracks to ~/.spobbilog")
    sys.stdout.flush()
    scrob = scrobbify.Scrobbify(cb, interface='en1')
    scrob.start()
    try:
        while True:
            time.sleep(2**20)
    except (KeyboardInterrupt, SystemExit):
        scrob.stop()
