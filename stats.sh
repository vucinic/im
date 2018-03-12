#!/bin/bash


printf "\n\n\n"

echo "invs        total found invariants"
echo "usefull     invariants without unprocessable data for IM"
echo "            (eg. 'has only one value', 'orig', 'return')"
echo "distinct    non-duplicated invariants"
echo "locals      invariants that involve only local variables (distinct)"
echo "globals     invariants that involve a global variable (distinct)"


printf "\n\n\n%-70s %10s %10s %10s %10s %10s\n" "File name" "invs" "useful" "distinct" "locals" "globals"
echo  "-----------------------------------------------------------------------------------------------------------------------------"

for file in $(ls $(dirname $0))
do

    if  echo ${file} | grep "txt" > /dev/null
    then

        totalInv=$(sed "/======/{N;d}" $file | wc -l)

        usefulInv=$(sed "/======/{N;d}" $file | grep -v "has only one value" | grep -v "\orig" | grep -v "return" | grep -v "one of" | wc -l)

        usefulDistinctInv=$(sed "/======/{N;d}" $file | grep -v "has only one value" | grep -v "\orig" | grep -v "return" | grep -v "one of" | sort -u | wc -l)

        usefulDistLocalInv=$(sed "/======/{N;d}" $file | grep -v "has only one value" | grep -v "\orig" | grep -v "return" | grep -v "one of" | sort -u | grep -v "::" | wc -l)

        usefulDistGlobalInv=$(sed "/======/{N;d}" $file | grep -v "has only one value" | grep -v "\orig" | grep -v "return" | grep -v "one of" | sort -u | grep "::" | wc -l)

        printf "%-70s %10s %10s %10s %10s %10s\n" "$file" "$totalInv" "$usefulInv" "$usefulDistinctInv" "$usefulDistLocalInv" "$usefulDistGlobalInv"

    fi

done

