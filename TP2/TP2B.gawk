BEGIN {FS=";";NF=27;RS="\r\n";} 
NR>=3   {
        if($2=="")$2="N/A";
        if($3=="")$3="N/A";
        if($4=="")$4="N/A";
        if($27=="")$27="N/A";
        printf "CÓDIGO->"$2 "\nTITULO->"$3"\nDESCRIÇÃO->"$4"\nNOTA->"$27"\n--------------------------------------------------\n";total++} 
END     {printf "\nNúmero total de registos é:" total "\n"} 