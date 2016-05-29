To create energies for different thicknesses

1. First create a folder (any name is fine)
2. Copy "process.bash" and "post_process.bash" into that folder
3. Run "process.bash"
4. After, run "post_process.bash"


## process.bash ##

This script runs 20 folders each having different interlayer widths from 0%Cs to 100%Cs where K is randomly substituted with Cs.

We perform 20 replicas so that we can take care of the noise due to random substitution
If we run fewer replica, plots are not that great


When running on clusters (For example NERSC), running 20 iterations sequentually is too time consuming and perhaps will exceed max limits provided by the queue.
So please change the first line of process.bash "{1..20}" to "{1..5}" and rename the file to something else run for 5 replicas.
That way, we can start 4 jobs each running for 5 replicas only.

for example: 
process_1_5.bash can have the first line as "for file in {1..5}"
process_6_10.bash can have the first line as "for file in {6..10}"
process_11_15.bash can have the first line as "for file in {11..15}"
process_6_20.bash can have the first line as "for file in {16..20}"

Please run post_process.bash only after all 20 replicas are done so that proper statistics are computed


## post_process.bash ##

Running this will collate statistics and create a series of files

data.cs*: 
One does not have to care for these

collate.data.*: (collate.data.0 is for 0% Cs)
First column is the width. 20 is 0 Angstorm deviant from ideal illite. 40 is +2.0 angstorm deviant. Hence the actual distance is given by (d-20)/10

collate_all.data
Collates the interlayer distance for which energy is the minimum for a given concentration. As before that interlayer distance is (d-20)/10