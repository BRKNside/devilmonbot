#!/bin/bash
if [ ! -f latest_id.txt ]; then
	echo -n '"0"' >> latest_id.txt
fi
curl https://www.withhive.com/api/help/notice_list/1 > data.json
gamedata=`jq ['.result[] | select(.GameName=="Summoners War")'][0] data.json`
echo $gamedata
echo -n $gamedata > data.json
game=`jq .GameName data.json`
id=`jq .NoticeId data.json`
latest=`cat latest_id.txt`
echo $id
echo $latest
if [ "$id" == "$latest" ]; then
	echo "Nothing new"
else
	title=`jq .Title data.json`
	eventtype=`jq .TypeString data.json`
	startt=`jq .StartTime_Ymd data.json`
	echo $id > latest_id.txt
	echo "Match. Pulling data"
	echo $id
	echo -n '{"content":"New ' > output.json
	echo -n $eventtype| sed 's/"//g' >> output.json
	echo -n ' (' >> output.json
	echo -n $startt | sed 's/"//g' >> output.json
	echo -n ') ' >> output.json
	echo -n $title | sed 's/"//g' >> output.json
	echo -n ' https://www.withhive.com/help/notice_view/' >> output.json
	echo -n $id | sed 's/"//g' >> output.json
	echo -n '"}' >> output.json
	curl -H "Content-Type: multipart/form-data" -X POST --data @output.json "https://discordapp.com/api/webhooks/449604874154409985/KuWRuPRT2fEUBy1bSYsEVcG-oTrGU8cGSOXrnyX4WnxBDNP2InwriorpB6a8WWBRiNCQ"
fi

