import praw
import feedparser
import time
import calendar

class vari():
    r = praw.Reddit(user_agent='RSS Bot')
    #bot information
    bot_usr = 'username'
    bot_pss = 'password'
    bot_rss = 'rsslink'
    bot_sr = 'thetechgame'
    last_post = 0
#Enum Broadcast Type
class BCType:
    Info=1
    Alert=2
    Login=3
    Post=4
    Sleep=5
#Broadcast
def Broadcast(BCType, message):
    if (BCType == 1):
        print '[INFO] ' + message
    elif (BCType == 2):
         print '[ALERT] ' + message
    elif (BCType == 3):
         print '[LOGIN] ' + message
    elif (BCType == 4):
         print '[POST] ' + message
    elif (BCType == 5):
         print '[SLEEP] ' + message
#Login
def Login(Username, Password):
    vari.r.login(Username, Password)
    #time.sleep(3)
    if (vari.r.is_logged_in() == False):
        Broadcast(BCType.Login, 'Failed to log in as ' + Username + '. Retrying in 90 seconds')
        time.sleep(90)
        Login(Username, Password)
    else:
        Broadcast(BCType.Login, 'Logged in as ' + Username)
#RSSCheck
def RSSPost():
    Broadcast(BCType.Info, 'Preparing bot ' + vari.bot_usr)
        
    to_post = []
    
    #get the rss data
    feed = feedparser.parse(vari.bot_rss)

    #get the latest story as of the time the bot starts up
    try:
        last_post = feed.entries[0].published
    except:
        #yet another issue parsing the feed, so just assume vari holds the last post
        last_post = vari.last_post

    if(vari.last_post == 0):
        vari.last_post = last_post
    

    Broadcast(BCType.Info, 'Last story published by source: '+str(last_post)+', last story posted to Reddit: '+str(vari.last_post))

    for e in feed.entries:
        try:
            #if the data came after the last check, add it to the post queue
            if (e.published > vari.last_post):
                to_post.append(e)
        except:
            pass

    #if we have something to post...
    if (len(to_post) > 0):
        Broadcast(BCType.Info, str(len(to_post)) + ' links need to be posted')
        #login...
        Login(vari.bot_usr, vari.bot_pss)  
        #post each link
        for e in to_post:
            try:
                vari.r.submit(vari.bot_sr, e.title, url=e.link)
                Broadcast(BCType.Post, vari.bot_usr + ' Posted ' + e.title)
                time.sleep(60)
            except Exception as e:
                Broadcast(BCType.Info, 'error: '+str(e))
    else:
        Broadcast(BCType.Info, 'Nothing needs to be posted')

    #update the last post so we don't post duplicate stories
    vari.last_post = last_post
#Main#
while (True):
    #Check for new posts
    try:
        RSSPost()
        #Sleep until the next check
        Broadcast(BCType.Sleep, 'Sleeping for 30 minutes')
        time.sleep(1800)
        RSSPost()
    except Exception as e:
        Broadcast(BCType.Alert, 'RSSbot exception: '+str(e)+'. Trying again in 30 seconds.')
        time.sleep(30)
        RSSPost()
#Done
Broadcast(BCType.Alert, 'Program Done')