#!/bin/bash
"exec" "snakemake" "--printshellcmds" "--jobs" "4" "--snakefile" "$0"

import glob
import os
import re
import pandas as pd


def get_sample_data():
    df = pd.read_csv('/ceph/projects/tomoyo_SETD1A_bulk_RNA-seq_npcneuron/metadata/_m/metadata.tsv', sep='\t')
    df = df[["New_SampleID2","bam_path"]]
    for x in df.itertuples(index=False, name=None):
        d = dict(zip(df.columns, x))
        yield (d['New_SampleID2'], d)
        
        
sample_dict = dict(get_sample_data())


#snakemake starts here
rule all:
    input:
        expand('{sample}_fastqc.html', sample=sample_dict.keys())
rule fastqc:
    input:
        lambda x: sample_dict[x.sample]['bam_path']
    output:
        '{sample}_fastqc.html'
    log:
        '{sample}.log'
    params:
        fastqc = '/ceph/opt/FastQC/fastqc'
    shell:
        """
        {params.fastqc} \
        -t 4 \
        -o . \
        {input} > {log} 2>&1
        """
