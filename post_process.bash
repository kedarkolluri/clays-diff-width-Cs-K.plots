for file in {1..20}
do
  if [ -d r$file ]
  then
    for file2 in `seq 0 10 101`
    do
      if [ -d r$file/cs$file2 ]
      then
        touch tmp.cs$file2
        awk '{printf("%d %lf %lf\n", $1, $4, $5)}' r$file/cs$file2/en.output > tmp.data
        paste tmp.data tmp.cs$file2 > data.cs$file2
        cp data.cs$file2 tmp.cs$file2
      fi
    done
  fi
done
rm tmp.*
if [ -e collate_all.data ]
then
  rm collate_all.data
fi
for file in `seq 0 10 101`
do
  if [ -e data.cs$file ]
  then
    awk 'BEGIN{init=0}
        {
          sum = 0; sumsq = 0;count = 0;
          for(i = 2; i <=NF; i=i+3)
          {
            sum = sum + $i;
            sumsq = sumsq + $i*$i;
            count = count + 1;
          }
          if(NR==1) init = sum/count
          if(count > 1)
          {
            printf("%lf %lf %lf\n", $1, sum/count-init, sqrt(sumsq-(sum*sum/count))/(count-1))
          }else
          {
            printf("%lf %lf %lf\n", $1, sum/count-init, 0)
          }
        }' data.cs$file > collate.data.$file
    awk 'BEGIN {minE=0; deld=0} {if ($2 < min) {deld = $1; min = $2;} } END {printf("%lf %lf\n", '$file', deld) }' collate.data.$file >> collate_all.data
  fi
done
