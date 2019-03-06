#!/bin/bash

function merge_directory
{
    echo merge_directory $1 $2
    local localDir=$1
    local localDirLength=${#localDir}
    local coreDir=$2

    for current in $localDir/*
    do
        local coreEquivalent=$coreDir${current:$localDirLength}
        if [ -d "$current" ]
        then
          merge_directory "$current" "$coreEquivalent"
        else
          local oldFile="/tmp/tmp-merge-old-`basename \"$coreEquivalent\"`"
          local newFile="/tmp/tmp-merge-new-`basename \"$coreEquivalent\"`"
          if [ -f "$coreEquivalent" ]
          then
            git show HEAD~1:$coreEquivalent > $oldFile
            diff3 -m "$current" "$oldFile" "$coreEquivalent" > "$newFile"
            if [ $? == 1 ]
            then
              echo "CONFLICT: $current"
            fi
            cp $newFile $current
          else
            echo "Skipping $current; no equivalent in core code."
          fi
        fi
    done
}

#TODO - figure out how to merge import/config changes (they are in a separate private repo)
#merge_directory local/import import
#merge_directory local/config/vufind config/vufind
merge_directory themes/crraboot/templates themes/bootstrap3/templates
