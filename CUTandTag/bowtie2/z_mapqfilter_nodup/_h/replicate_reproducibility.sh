#!/bin/bash     
"exec" "snakemake" "--printshellcmds" "--jobs" "6" "--snakefile" "$0"


import glob
import os.path
import itertools


import pandas as pd

def get_sample_data():
    df = pd.read_csv('/ceph/projects/tomoyo_SETD1A_cut-tag/metadata/_m/metadata_allsamples_CUTTAG.tsv', sep='\t')
    df = df.loc[df['Sequence_ID'] == '2104UNHP-0893']
    for x in df.itertuples(index=False, name=None):
        d = dict(zip(df.columns, x))
        yield (d['New_Sample_ID'], d)

        
sample_dict = dict(get_sample_data())

rule all:
    input:
       expand('bed/{sample}_bowtie2.fragmentsCount.bin.bed', sample=sample_dict.keys())
       

 #minQualityScore=2
rule rep_reprod:
    input:
        'bed/{sample}_bowtie2.fragments.bed'
    output:
        'bed/{sample}_bowtie2.fragmentsCount.bin.bed'
        
    params:
        binLen = '500'
        
    shell:
        """    
        awk -v w={params.binLen} '{{print $1, int(($2 + $3)/(2*w))*w + w/2}}' {input} | sort -k1,1V -k2,2n | uniq -c | awk -v OFS="\t" '{{print $2, $3, $1}}' |  sort -k1,1V -k2,2n  > {output}
        """

    