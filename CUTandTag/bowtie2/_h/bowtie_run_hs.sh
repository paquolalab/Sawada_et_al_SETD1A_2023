#!/bin/bash
"exec" "snakemake" "--printshellcmds" "--jobs" "10" "--snakefile" "$0"

import glob
import os.path
import itertools


import pandas as pd

def get_sample_data():
    df = pd.read_csv('/ceph/projects/tomoyo_SETD1A_cut-tag/metadata/_m/filepath_2104UNHP-0893.tsv', sep='\t')
    for x in df.itertuples(index=False, name=None):
        d = dict(zip(df.columns, x))
        yield (d['Assay'], d)
        
       
sample_dict = dict(get_sample_data())

rule all:
    input:
       expand('sam/{sample}_bowtie2.sam', sample=sample_dict.keys())

rule hs:
    output:
        'sam/{sample}_bowtie2.sam'
        
    params:
        r1 = lambda w: sample_dict[w.sample]['R1_fastq'],
        r2 = lambda w: sample_dict[w.sample]['R2_fastq'],
        index_hs = '/ceph/genome/human/hg38.p12/bowtie2/_m/index/hg38'
        
    log:
        hs_log = 'sam/bowtie2_summary/{sample}_bowtie2.log'
        
    shell:
        """              
        bowtie2 --end-to-end --very-sensitive --no-mixed --no-discordant --phred33 -I 10 -X 700 -p 6 -x {params.index_hs} -1 {params.r1} -2 {params.r2} -S {output} &> {log.hs_log}
        """
        
        
