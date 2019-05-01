BEGIN {FS=";";NF=27;RS=";;;;;;;\r\n";} 
        {gsub("\r\n","")}
        {for(i=1;i<=NF;i++)if($i==""){k=0}else{k=1;break};if(k==0) next}
        {for(i=1;i<=NF ;i++)if(i==NF) printf "\r\n"}
$1!=""  {for(i=1;i<=NF ;i++){printf $i";"};next}
$1==""  {printf "NIL;";for(i=2;i<=NF;i++){printf $i";"};next}


END     {}