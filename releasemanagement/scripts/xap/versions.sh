#!/bin/bash -x
BRANCH_NAME_FOR_TEST=$(echo $BRANCH_NAME_FOR_TEST)
echo "BRANCH_NAME_FOR_TEST=$BRANCH_NAME_FOR_TEST"

for dir in `pwd`/*/
do
        dir=${dir%*/}
        repo=${dir##*/}
	if [ "$repo" != "examples" ]
	then	
		echo "### Processing repository: $repo"
		pushd $repo
			if [ -n "$BRANCH_NAME_FOR_TEST" ] && [[ `git branch -r | grep origin/$BRANCH_NAME_FOR_TEST` ]]
	 		then
				if [[ `git branch | grep $BRANCH_NAME_FOR_TEST` ]] 
				then
					git checkout $BRANCH_NAME_FOR_TEST
				else			
					git checkout -b $BRANCH_NAME_FOR_TEST origin/$BRANCH_NAME_FOR_TEST
				fi
				#exit_on_error
				git reset --hard origin/$BRANCH_NAME_FOR_TEST
				#exit_on_error
			else
				git checkout master
				git reset --hard origin/master
			fi
			git pull
			sha=$(git rev-parse HEAD)
	 		if [[ -z "$repo_names_sha" ]];then
	 			repo_names_sha='[ "'$repo'":"'$sha'"'	
	 		else
	 			repo_names_sha=$repo_names_sha',"'$repo'":"'$sha'"'
	 		fi
		popd
	fi
done
repo_names_sha=$repo_names_sha' ]'
echo $repo_names_sha > repo_names_sha
