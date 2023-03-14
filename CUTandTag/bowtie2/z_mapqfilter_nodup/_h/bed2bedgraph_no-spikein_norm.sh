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
       expand('bedgraph/{sample}_bowtie2.fragments.no_spikein.bedgraph', sample=sample_dict.keys())
       
 #minQualityScore=2
rule spikein_norm:
    input:
        in2 = 'bed/{sample}_bowtie2.fragments.bed'

    output:
        'bedgraph/{sample}_bowtie2.fragments.no_spikein.bedgraph'
        
    params:
        chromSize = '/ceph/genome/human/hg38.p12/bowtie2/_m/index/hg38.chrom.sizes'
               
    shell:
        """
        bedtools genomecov -bg -i {input.in2} -g {params.chromSize} > {output}
        """

# scalefactor here