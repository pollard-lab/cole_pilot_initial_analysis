#!/bin/bash
# this script performs QC/ adapter trimming on all read in the dataset, using cutadapt (v1.16) and fastQC (v0.11.5)
# multiple steps were performed, and after each step the program fastQC was run to generate a report after each step

input=$(echo "/media/pollardlab/POLLARDLAB3/Cole_data/Cole_Pilot_001_S5_R1_001.fastq")

echo "##### 3' Adapter Trimming #####"
output_1=$(echo $input | cut -d'.' -f1)"_adapterTrim.fastq"  # this adds some text to the output file name, in this case '_adaptersTrim' is added
cutadapt -a GATCGGAA -o $output_1 $input
# -a GATCGGAA (removes adapters from 3' end (all adapters were TruSeq HT adapters (D701-D712))). See 'TruSeq_HT_Adapters_F_R.fasta' for a list of all adapters used in the library prep protocol

mkdir adapterTrim_QC
fastqc -o adapterTrim_QC $output_1
echo
echo
echo


echo "##### 3' PolyA Removal #####"
output_2=$(echo $output_1 | cut -d'.' -f1)"_polyATrim.fastq"
cutadapt -a AAAAAAAAAA -o $output_2 $output_1
# -a AAAAAAAAAA (removes all polyA tails)

mkdir polyATrim_QC
fastqc -o polyATrim_QC $output_2
echo
echo
echo


echo "##### 3' Quality Removal #####"
output_3=$(echo $output_2 | cut -d'.' -f1)"_qualityTrim.fastq"
cutadapt -q 10 -o $output_3 $output_2
# -q 10 (from the 3' end uses the BWA quality control method (see cutadapt manual) to remove bases of poor quality, 10 is how much each quality is subtracted during the first step of the method)

mkdir qualityTrim_QC
fastqc -o qualityTrim_QC $output_3
echo
echo
echo


echo "##### 5' Three nts Removal, Length Filtering #####"
output_4=$(echo $output_3 | cut -d'.' -f1)"_frontTrim_lenFilter.fastq"
cutadapt -u 3 -m 15 -o $output_4 $output_3
# -u 3 (the first three nucleotides (5' end) will be removed, they are remnants of the adapter ligation process (from the template-switching oligo)
# -m 15 (any read less than 15nts in length will be dropped)

mkdir frontTrim_lenFilter_QC
fastqc -o frontTrim_lenFilter_QC $output_4

echo
echo "Script Done."
# the final fastq file ready to use in future steps is named 'Cole_Pilot_001_S5_R1_001_adapterTrim_polyATrim_qualityTrim_frontTrim_lenFilter.fastq'