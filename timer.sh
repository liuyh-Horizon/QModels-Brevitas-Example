#!/bin/bash
while true; 
do 
    # check status
        git status
    # add new file
	git add .
    # don't send message
	git commit --allow-empty-message -m ""
    #update github
	git push
    #done
	echo -e "\033[1;34mgit push finished.\033[m"
    sleep 5; 
done
