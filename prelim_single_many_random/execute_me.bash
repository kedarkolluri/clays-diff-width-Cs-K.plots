create_structfile()
{
  seedforfile=1
  filename="USETHIS-6by4by2_structure-Si2Al.xyz"
  if [ ! -z "$1" ]
  then
    seedforfile=$1
  fi
  if [ ! -z "$2" ]
  then
    filename=$2
  fi
  echo $seedforfile
  lbnl_processor_latest_exec.out convert_VESTA filename 6by4by2_structure-Si2Al.xyz make_illite keep_ghosts CUTOFF_FILE /Users/KedarKolluri/lib/cutoff_file.illite.make rand_seed $seedforfile SAVE_LAMMPS CHARGE MOLECULE > out.out
  cp dat_VESTA.20.xyz $filename

  awk '{if(NR==1) print $0}' $filename > modif-$filename
  awk '{if(NR==2) print $0}' 6by4by2_structure-Si2Al.xyz >> modif-$filename
  awk '{if(NR>2) print $0}' USETHIS-6by4by2_structure-Si2Al.xyz >> modif-$filename
  mv modif-$filename $filename
}

test_diffs()
{
  diff lammps_files_1/dat_lammps.0 lammps_files_2/dat_lammps.2 | wc | awk '{if ($1>0) {print "success"} else {print "failure"}}'
}


vval=1
initval=-1.0
for itermain in {1..20}
do
  create_structfile $itermain
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
#    mv out.$iter lammps_files_$itermain/
  done
#  mv lammps_files/* lammps_files_$itermain/
done
rm dat_VESTA.10.xyz dat_lammps.10
rm out.* 
rm 6by4by1_structure-Si2Al-*
test_diffs
