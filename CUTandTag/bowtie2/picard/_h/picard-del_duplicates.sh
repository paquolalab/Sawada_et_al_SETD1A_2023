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
#sample_dict = {k: sample_dict[k] for k in list(sample_dict)[:2]} #snakemake test

rule all:
    input:
        expand('rmDuplicate/{sample}_bowtie2.sorted.rmDup.sam', sample=sample_dict.keys())

rule picard:
    output:
        out1 = 'rmDuplicate/{sample}_bowtie2.sorted.rmDup.sam',
        out2 = 'rmDuplicate/picard_summary/{sample}_picard.rmDup.txt',
        out3 = 'sam/fragmentLen/{sample}_fragmentLen.txt'
    params:
        bowtie2_sam_input = 'sam/{sample}_bowtie2.sorted.sam',
        picard_jar = 'java -jar /ceph/opt/picard.jar',
        bowtie2_sam_input2 = '../../_m/sam/{sample}_bowtie2.sam'        
                
    shell:
        """
        {params.picard_jar} MarkDuplicates \
        I={params.bowtie2_sam_input} \
        O={output.out1} \
        REMOVE_DUPLICATES=true \
        METRICS_FILE={output.out2}
        
        samtools view -F 0x04 {params.bowtie2_sam_input2} | awk -F'\t' 'function abs(x){{return ((x < 0.0) ? -x : x)}} {{print abs($9)}}' | sort | uniq -c | awk -v OFS="\t" '{{print $2, $1/2}}' >{output.out3}

        """