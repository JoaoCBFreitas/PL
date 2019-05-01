BEGIN {FS=";";NF=27;RS="\r\n";} 
NR>=3    {tipo[$11]++}                           
END      {for(x in tipo){if(x!=""){print x"--->" tipo[x]}else{print "Desconhecido--->" tipo[x]}}} 