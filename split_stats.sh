#!/bin/bash

oldDir=$(pwd)

mkdir $(dirname $0)/"tmp"

cd $(dirname $0)/"tmp"

rm -f ./xx*

for file in $(ls ../*.txt)
do

    echo  "-----------------------------------------------------------------------------------------------------------------------------"
    echo "File $file"
    echo  "-----------------------------------------------------------------------------------------------------------------------------"

	csplit $file '/^=====*$/' '{*}' -s

	for sFile in $(ls ./xx*)
	do
	    if [ -f $sFile ]
	    then
            if [ "$(cat $sFile)" == "" ]        
            then
                rm -f $sFile
                continue
            fi
        else
            continue
        fi
        
        
        funcName=$(head -n 2 $sFile | grep -v ==== | sed 's/:::ENTER//' | sed 's/:::EXIT//')
         
	    
    	for sFile2 in $(ls ./xx*)
    	do
    	 
    	    if [ "$sFile" != "$sFile2" ]
    	    then
	        
       	        funcName2=$(head -n 2 $sFile2 | grep -v ==== | sed 's/:::ENTER//' | sed 's/:::EXIT//')
  	    
        	    if [ "$funcName" == "$funcName2" ]
        	    then
        	        cat $sFile2 >> $sFile
        	        rm -f $sFile2
        	    fi
            fi
       	done
	done
	
	printf "%-70s %10s %10s %10s %10s %10s\n" "Function" "invs" "useful" "distinct" "locals" "globals"
    echo  "-----------------------------------------------------------------------------------------------------------------------------"


	for sFile in $(ls ./xx*)
	do
	
        funcName=$(head -n 2 $sFile | grep -v ==== | sed 's/:::ENTER//' | sed 's/:::EXIT//')

        totalInv=$(sed "/======/{N;d}" $sFile | wc -l)

        usefulInv=$(sed "/======/{N;d}" $sFile | grep -v "has only one value" | grep -v "\orig" | grep -v "return" | grep -v "one of" | wc -l)

        usefulDistinctInv=$(sed "/======/{N;d}" $sFile | grep -v "has only one value" | grep -v "\orig" | grep -v "return" | grep -v "one of" | sort -u | wc -l)

        usefulDistLocalInv=$(sed "/======/{N;d}" $sFile | grep -v "has only one value" | grep -v "\orig" | grep -v "return" | grep -v "one of" | sort -u | grep -v "::" | wc -l)

        usefulDistGlobalInv=$(sed "/======/{N;d}" $sFile | grep -v "has only one value" | grep -v "\orig" | grep -v "return" | grep -v "one of" | sort -u | grep "::" | wc -l)

        printf "%-70s %10s %10s %10s %10s %10s\n" "$funcName" "$totalInv" "$usefulInv" "$usefulDistinctInv" "$usefulDistLocalInv" "$usefulDistGlobalInv"
       
    done
    
    
	echo  "-----------------------------------------------------------------------------------------------------------------------------"
    echo ""	
    
    rm -f ./xx*

done 

cd $oldDir

rm -rf $(dirname $0)/"tmp"/*

rmdir $(dirname $0)/"tmp"


