BEGIN {FS=";";NF=27;RS="\r\n";print "digraph{";print "rankdir=LR"} 
        {gsub("\"","")}
NR>=3 {if($8!=""){split($8,lei,"#");for(i=1;lei[i]!=NULL;i++){printf $2"->\""lei[i]"\";\n"}}}
NR>=3 {if($9!=""){split($9,lei,"#");for(i=1;lei[i]!=NULL;i++){printf $2"->\""lei[i]"\";\n"}}}
END{print "}"}

