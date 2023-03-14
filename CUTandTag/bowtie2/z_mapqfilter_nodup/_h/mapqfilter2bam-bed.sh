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
       expand('sam/{sample}_bowtie2.minQualityScore.sam', sample=sample_dict.keys())
       

 #minQualityScore=2
rule mapq_convert:
    output:
        'sam/{sample}_bowtie2.minQualityScore.sam'
    params:
        in1 = '../../picard/_m/rmDuplicate/{sample}_bowtie2.sorted.rmDup.sam',
        minQualityScore = '2',
        out1 = 'bam/{sample}_bowtie2.mapped.bam',
        out1_sorted = 'bam/{sample}_bowtie2.mapped_sorted.bam',
        out2 = 'bed/{sample}_bowtie2.bed',
        out3 = 'bed/{sample}_bowtie2.clean.bed',
        out_frag = 'bed/{sample}_bowtie2.fragments.bed'
        
    shell:
        """
        
        samtools view -h -q {params.minQualityScore} {params.in1} > {output}
        samtools view -bS -F 0x04 {output} > {params.out1}
        
        samtools sort -n {params.out1} > {params.out1_sorted} # change the sorting options

 
        bedtools bamtobed -i {params.out1_sorted} -bedpe > {params.out2}

        awk '$1==$4 && $6-$2 < 1000 {{print $0}}' {params.out2} > {params.out3}

        cut -f 1,2,6 {params.out3} | sort -k1,1 -k2,2n -k3,3n  > {params.out_frag}
        """
