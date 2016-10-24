echo clean
sudo rm *.txt
sudo rm *.csv

echo unpack zip file
unzip -o archive/perf_dump.txt.zip -d .

#powershell -Command "type perf_dump.txt | ForEach-Object { $_ -replace '\|', ',' } | Set-Content perf_dump_tmp.csv"

echo make it coma delimited
sed -e 's/|/,/g' perf_dump.txt > perf_dump_tmp.csv

echo remove header
tail -n +2 perf_dump_tmp.csv > perf_dump.csv                                                                        

echo store header separately
head -n 1  perf_dump_tmp.csv > perf_dump_head.csv                                                                        

sudo rm perf_dump_tmp.csv

echo split files    
split --number=l/20  --suffix-length=1  perf_dump.csv  perf_dump_                                                    

echo rename file parts
for j in perf_dump_?; do mv -- "$j" "$j.csv"; done                                                                  