#!/bin/bash
set -o errexit -o pipefail

#cores=8
#projPath='../../alignment/_m'
seacr='/ceph/opt/SEACR-master/1.4-beta2/SEACR_1.4.sh'
path='/ceph/projects/tomoyo_SETD1A_cut-tag/2104UNHP-0893/bowtie2/z_mapqfilter_nodup/_m/bedgraph'
#IgG
mkdir -p ./peakCalling/SEACR
mkdir -p ./bigwig   

###############################

# H1
histControl1=${path}'/Br6184_Nuc_Rb_IgG_6C_bowtie2.fragments.no_spikein.bedgraph'
histName1=(Br6184_Nuc_H3K4me1_6D Br6184_Nuc_H3K4me2_6E Br6184_Nuc_H3K4me3_6F Br6184_Nuc_H3K27ac_6G  Br6184_Nuc_SETD1A_CST_6H Br6184_Nuc_SETD1A_Atlas_7A)



for i in "${histName1[@]}"
do

    bash $seacr -b ${path}/${i}_bowtie2.fragments.no_spikein.bedgraph -c $histControl1 -n norm -m stringent -o peakCalling/SEACR/${i}_seacr_control.peaks
    cut -f 6 peakCalling/SEACR/${i}_seacr_control.peaks.stringent.bed |
    perl -n -e'/([^:]+):(\d+)-(\d+)/ && print $1, "'"\t"'", int(($3+$2)/2), "'"\t"'",int(($3+$2)/2+1),"'"\n"'";' > peakCalling/SEACR/${i}_seacr_control_summit.peaks.stringent.bed

    bash $seacr -b ${path}/${i}_bowtie2.fragments.no_spikein.bedgraph -c 0.01 -n norm -m stringent -o peakCalling/SEACR/${i}_seacr_top001.peaks
    cut -f 6 peakCalling/SEACR/${i}_seacr_top001.peaks.stringent.bed |
    perl -n -e'/([^:]+):(\d+)-(\d+)/ && print $1, "'"\t"'", int(($3+$2)/2), "'"\t"'",int(($3+$2)/2+1),"'"\n"'";' > peakCalling/SEACR/${i}_seacr_top001_summit.peaks.stringent.bed

done



###############################

# I1
histControl1=${path}'/Br5774_Nuc_Rb_IgG_7B_bowtie2.fragments.no_spikein.bedgraph'
histName1=(Br5774_Nuc_H3K4me1_7C Br5774_Nuc_H3K4me2_7D Br5774_Nuc_H3K4me3_7E Br5774_Nuc_H3K27ac_7F  Br5774_Nuc_SETD1A_CST_7G Br5774_Nuc_SETD1A_Atlas_7H)



for i in "${histName1[@]}"
do

    bash $seacr -b ${path}/${i}_bowtie2.fragments.no_spikein.bedgraph -c $histControl1 -n norm -m stringent -o peakCalling/SEACR/${i}_seacr_control.peaks
    cut -f 6 peakCalling/SEACR/${i}_seacr_control.peaks.stringent.bed |
    perl -n -e'/([^:]+):(\d+)-(\d+)/ && print $1, "'"\t"'", int(($3+$2)/2), "'"\t"'",int(($3+$2)/2+1),"'"\n"'";' > peakCalling/SEACR/${i}_seacr_control_summit.peaks.stringent.bed

    bash $seacr -b ${path}/${i}_bowtie2.fragments.no_spikein.bedgraph -c 0.01 -n norm -m stringent -o peakCalling/SEACR/${i}_seacr_top001.peaks
    cut -f 6 peakCalling/SEACR/${i}_seacr_top001.peaks.stringent.bed |
    perl -n -e'/([^:]+):(\d+)-(\d+)/ && print $1, "'"\t"'", int(($3+$2)/2), "'"\t"'",int(($3+$2)/2+1),"'"\n"'";' > peakCalling/SEACR/${i}_seacr_top001_summit.peaks.stringent.bed

done

###############################

# J1
histControl1=${path}'/Br5844_Nuc_Rb_IgG_8A_bowtie2.fragments.no_spikein.bedgraph'
histName1=(Br5844_Nuc_H3K4me1_8B Br5844_Nuc_H3K4me2_8C Br5844_Nuc_H3K4me3_8D Br5844_Nuc_H3K27ac_8E  Br5844_Nuc_SETD1A_CST_8F Br5844_Nuc_SETD1A_Atlas_8G)



for i in "${histName1[@]}"
do

    bash $seacr -b ${path}/${i}_bowtie2.fragments.no_spikein.bedgraph -c $histControl1 -n norm -m stringent -o peakCalling/SEACR/${i}_seacr_control.peaks
    cut -f 6 peakCalling/SEACR/${i}_seacr_control.peaks.stringent.bed |
    perl -n -e'/([^:]+):(\d+)-(\d+)/ && print $1, "'"\t"'", int(($3+$2)/2), "'"\t"'",int(($3+$2)/2+1),"'"\n"'";' > peakCalling/SEACR/${i}_seacr_control_summit.peaks.stringent.bed

    bash $seacr -b ${path}/${i}_bowtie2.fragments.no_spikein.bedgraph -c 0.01 -n norm -m stringent -o peakCalling/SEACR/${i}_seacr_top001.peaks
    cut -f 6 peakCalling/SEACR/${i}_seacr_top001.peaks.stringent.bed |
    perl -n -e'/([^:]+):(\d+)-(\d+)/ && print $1, "'"\t"'", int(($3+$2)/2), "'"\t"'",int(($3+$2)/2+1),"'"\n"'";' > peakCalling/SEACR/${i}_seacr_top001_summit.peaks.stringent.bed

done


 
exit



