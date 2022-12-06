#!/bin/bash

# load argument number
((num = $#))

#check argument number
if [ $num -eq 0 ];
then
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
else
	# check status
	git status
        # add new file
        git add .
        # input submission message
	git commit -m "$*"
        #update github
        git push
	#done
	echo -e "\033[1;34mgit push finished.\033[m"
fi
