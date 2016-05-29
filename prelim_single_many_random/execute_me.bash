vval=1
initval=-1.0
for itermain in {1..20}
do
  mkdir lammps_files_$itermain
  for iter in `seq 0 1 40`
  do

    awk 'BEGIN{
          VAL='$iter'*0.05*'$vval'+'$initval';
          XVAL=-0.09871188639278138*VAL;
          ZVAL= 0.9951160552843967*VAL;}
        {
          if(NR==2)
          {
            printf("%lf %lf %lf %lf %lf %lf\n", $1, $2, $3+VAL, $4, $5, $6)
          }else
          {
            if($4 > 9.8)
            {
              if(($1=="K")||($1=="Gh"))
              {
                printf("%s1 %lf %lf %lf\n", $1, $2, $3, $4)
              } else
              {
                print $0
              }
            }else
            {
              if(($1=="K")||($1=="Gh"))
              {
                printf("%s %lf %lf %lf\n", $1, $2-XVAL/2.0, $3, $4-ZVAL/2.0)
              } else
              {
                print $0
              }
            }
          }

        }
        ' USETHIS-6by4by2_structure-Si2Al.xyz > 6by4by1_structure-Si2Al-$iter.xyz
# source for this exec is in https://github.com/kkolluri/processor.lbnl.clays. compile inside Src (other sources are not working)
# cutoff file is provided in this repo. please change it as you see fit
    lbnl_processor_latest_exec.out convert_VESTA filename 6by4by1_structure-Si2Al-$iter.xyz CUTOFF_FILE /Users/KedarKolluri/lib/cutoff_file.illite.make-cs-k1gh1 rand_seed $itermain SAVE_LAMMPS CHARGE MOLECULE > out.$iter 2>&1
    mv dat_lammps.20 lammps_files_$itermain/dat_lammps.$iter
    rm dat_VESTA.20.xyz
  done
#  mv lammps_files/* lammps_files_$itermain/
done
rm dat_VESTA.10.xyz dat_lammps.10
rm out.* 
rm 6by4by1_structure-Si2Al-*
#rm -rf lammps_files
