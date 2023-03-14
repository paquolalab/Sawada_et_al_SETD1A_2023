#!/bin/bash
"exec" "snakemake" "--printshellcmds" "--jobs" "5" "--snakefile" "$0"


import glob
import os.path
import itertools


import pandas as pd

def get_sample_data():
    df = pd.read_csv('/ceph/projects/tomoyo_SETD1A_cut-tag/metadata/_m/filepath_2104UNHP-0893.tsv', sep='\t')
#    df = df[0:10] #test w/ 10 samples
    for x in df.itertuples(index=False, name=None):
        d = dict(zip(df.columns, x))
        yield (d['Assay'], d)
        
       
sample_dict = dict(get_sample_data())
#sample_dict = {k: sample_dict[k] for k in list(sample_dict)[:4]} #snakemake test

rule all:
    input:
        expand('sam/{sample}_bowtie2.sorted.sam', sample=sample_dict.keys())

rule picard1:
    output:
        'sam/{sample}_bowtie2.sorted.sam'
        
    params:
        bowtie2_sam_input = '../../_m/sam/{sample}_bowtie2.sam',
        picard_jar = 'java -jar /ceph/opt/picard.jar'
                
    shell:
        """
    
        {params.picard_jar} SortSam \
        I={params.bowtie2_sam_input} \
        O={output} \
        SORT_ORDER=coordinate

        """
