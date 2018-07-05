#!/bin/bash
# This script uses featureCounts(v1.5.3) on a sam alignent file and a gtf annotation file to generate a counts files. Each counts file consists of a single column for the 
# sam file, and rows coresponding to the annotations from the gtf, values (intigers) are the number of reads that mapped to that annotation. 
# Counts files were generated from a variety of gtf files. All of the gtf files except for TetGenomeRef.gtf are custom annotation files for sRNA precursor genmoic loci.
# TetGenomeRef.gtf was derived from http://www.ciliate.org/system/downloads/T_thermophila_June2014.gff3 (27002 KB - 6/27/2014) and represents all of the known genes in the 
# 2014 MAC genome.

## USAGE ##
# ./counting.sh  

sam_file=$(echo "/media/pollardlab/POLLARDLAB3/cole_pilot_initial_analysis/step2_alignment/Cole_Pilot_001_S5_R1_001_unique_and_all_MAC.sam")


featureCounts -s 1 -t exon -g gene_name -M -a Couvillion_sRNA_Precursor_Annotations_2014updated.gtf -o couvillion_counts.txt $sam_file
featureCounts -s 1 -t exon -g gene_name -M -a Farley_2017_TASL-introns_Ranges_forRNAi.gtf -o farley-introns_counts.txt $sam_file
featureCounts -s 1 -t exon -g gene_name -M -a Farley_2017_TASL_Ranges_forRNAi.gtf -o farley_counts.txt $sam_file
featureCounts -s 1 -t exon -g gene_name -M -a POTENTIAL_Couvillion_sRNA_Precursor_Annotations_2014updated.gtf -o couvillion-potential_counts.txt $sam_file
featureCounts -s 1 -t exon -g gene_name -M -a TetGenomeRef.gtf -o transcriptome_counts.txt $sam_file
# -s 1 (tells featureCounts to count on the forward strand)
# -t exon (tells featureCounts the feature type that is being counted )
# -g gene_name (tells featureCounts to report the counts using this name identifier from the gtf file (in every case it is 'gene_name' eventhough our custom annotations are not genes))
# -M (tells featurecounts to report/count multimappers)
# -a file.gtf (gives featureCounts the annotation set, gtf file)
# -o file.txt (tells featureCounts what the counts file name should be that is generated)
# $sam_file (tells featureCounts the sam file to run on)

mkdir counting_output_files
mv *.txt *.summary counting_output_files
