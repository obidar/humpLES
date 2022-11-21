#!/bin/bash

# read in the case name where caseName is generated when creating a file
cName=$( tail -n 1 caseName )

# clean-up if re-running an existing case
rm optHistory.*

# check if git branch exists for this case, if not create one
git fetch
git switch -c $cName
git pull $cName

count=2

while true; 
do 
    multiplier="0.00000001"
    # path to directory
    dir="0$(bc <<< "$count*$multiplier")"
    dirPath="$PWD/processor0/$dir"
    
    # add contition not to launch in the loop if the iteration has been already processed
    # for first iteration need to write the latestDir here
    if [ $count == 2 ]; then echo $dirPath > latestDir; fi

    if [[ -d "$dirPath" ]] && [ $dirPath!=$( tail -n 1 latestDir ) ]
    then
        # read last line
        lastLine=$( tail -n 1 opt_IPOPT.out )

        # write to file
        printf '%d,%e,%e,%e,%s,%e,%s,%e,%s,%s\n' $lastLine >> optHistory.csv
        
        # delete graph if it exists
        [ -f "optHistory.pdf" ] && rm optHistory.pdf

        # plot
        sed -i "2s/.*/time=$dir/" plotData.sh
        reconstructPar -time $dir
        postProcess -time $dir -func extractSurfacePressure && \
        postProcess -time $dir -func extractVelocityProfiles && \
        ./plotData.sh
        rm -rf $dir
        
        # need to sync data to Github
        git add plots.pdf
        git remote prune origin
        git commit -m "Opt history after $((count-2)) iterations."
        git push -u origin $cName

        #increase count
        count=$((count+1))
        
        # write the path to file, used to only enter loop for unique directory
        echo $dir > latestDir
        if [ $count -gt 200 ]; then exit; fi
    fi
    #### INCREASE THIS FOR THE FINAL CASE, i.e. check every hour
    sleep 10
done