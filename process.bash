start=1
end=20
if [ "$#" -eq 2 ]
then
  echo "input parameters being used for start and end"
  echo "no checks are made about the parameters"
  echo "This check merely to allow backward compatability, not general purpose utility code"
  start=$1
  end=$2
fi

for rootfile in $(seq $start $end)
do
  if [ -d r$rootfile ]
  then
  rm -rf r$rootfile
  fi
  mkdir r$rootfile
  sed -e 's/SEED/'$rootfile'/' ../lammps_scripts/in.addcesium_T_K1G1 > r$rootfile/in.addcesium_template;
  cd r$rootfile
  for file in `seq 0 10 101`
  do
    #echo $file
    mkdir cs$file
    sed -e 's/GFT/'$file'/' in.addcesium_template > cs$file/in.addcesium
    cd cs$file
    pwd
    if [ -e en.output ]
    then
      rm en.output
    fi
    for file2 in `seq 0 2 41`
    do
      echo $file2
      cp ../../../prelim_single_many_random/lammps_files_$rootfile/dat_lammps.$file2 dat_lammps.00
      if [ -e dat_lammps.00 ]
      then
        lmp_git_openmpi_021415 -in in.addcesium -screen none -log log.$file2
        awk '{if($1==40000) printf("%d %lf %lf %lf %lf\n", '$file2', $3, $4, $5, $6)}' log.$file2 >> en.output
        mv dat.40000.gz dat.$file2.gz;
      fi
      pwd
    done
    cd ../
  done
  cd ../
done
