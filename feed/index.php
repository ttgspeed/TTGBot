<?php
/*
	TheTechGame RSS Unfucker
	
	Author: https://github.com/ttgspeed/

	Usage:
		Parse TheTechGame's RSS feed and output it into a format that can actually be read by bots 
*/

//import a class that can actually handle TTG's retarded formatting, then load the feed
require_once 'rss_php.php';
$rss = new rss_php;
$rss->load('http://thetechgame.com/rss.php');

//set the header to xml so it's a valid feed
header("Content-Type: application/xml; charset=utf-8");

//parse TTG's feed
$feedItem = $rss->getItems();

//create the heading information of our new feed
$feed = '<?xml version="1.0" encoding="utf-8" ?>
<rss version="2.0">
 <channel>
  <title>The Tech Game</title>
  <link>http://www.thetechgame.com</link>
  <description>Community</description>
  <language>en-us</language>';

//load values from TTG's feed and put it into our own, in a format that can actually be read  
for($i = 0;$i < count($feedItem);$i++) {
	$feed .= '
	<item>
	<title>'.$feedItem[$i]['title'] .'</title>
	<link>'. $feedItem[$i]['link'] .'</link>
	<pubDate>'. substr($feedItem[$i]['guid'],0,4) .'</pubDate>
	</item>';
}

//feed done, close it off
$feed .= '</channel>
</rss>';

//ship the final product
echo $feed;
?>