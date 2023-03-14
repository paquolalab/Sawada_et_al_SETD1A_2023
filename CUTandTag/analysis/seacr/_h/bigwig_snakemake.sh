#!/bin/bash
"exec" "snakemake" "--printshellcmds" "--jobs" "12" "--snakefile" "$0"

import glob
import os
import os.path
import itertools
from toolz.dicttoolz import keyfilter
import pandas as pd

###create a dictionary with the samples

def get_sample_data():
    df = pd.read_csv('/ceph/projects/tomoyo_SETD1A_cut-tag_fetalbrain/metadata/_m/metadata_allsamples_CUTTAG_fetal.tsv', sep='\t')
    for x in df.itertuples(index=False, name=None):
        d = dict(zip(df.columns, x))
        yield (d['New_Sample_ID'], d)
       
sample_dict = dict(get_sample_data())



rule all:
    input:
        expand('bigwig/{sample}_raw.bw', sample=sample_dict.keys())

rule bigwig:
    output:
        'bigwig/{sample}_raw.bw'
        
    params:
        in_bam_sorted = '/ceph/projects/tomoyo_SETD1A_cut-tag/2104UNHP-0893/bowtie2/z_mapqfilter_nodup/_m/bam/{sample}.sorted.bam',
        in_bam_mapped = '/ceph/projects/tomoyo_SETD1A_cut-tag/2104UNHP-0893/bowtie2/z_mapqfilter_nodup/_m/bam/{sample}_bowtie2.mapped.bam'
        
    log:
        bigwig = 'bigwig/{sample}.log',
        
    shell:
        """
        samtools sort -o {params.in_bam_sorted} {params.in_bam_mapped}
        samtools index {params.in_bam_sorted}
        bamCoverage -b {params.in_bam_sorted} -o {output} > {log.bigwig}
        """
    







# ######
