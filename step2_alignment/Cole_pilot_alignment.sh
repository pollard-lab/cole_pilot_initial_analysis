#!/bin/bash
# This script generates sam alignent files using bowtie2 (v2.3.2) using the fastq file from STEP1_QC and the MAC and MIC Tetrahymena thermophila genomes. 

##USAGE##
# ./alignment.sh
# see the comments under the first bowtie2 command for the parameters used

##INPUTS##
# 1. MAC Genome (T_thermophila_June2014_assembly.fasta)
# 2. MIC Genome (T_thermophila_MIC_assembly.fasta)
# 3. fastq file of reads outputted from STEP1_QC (Cole_Pilot_001_S5_R1_001_adapterTrim_polyATrim_qualityTrim_frontTrim_lenFilter.fastq)

##OUTPUTS##
# 1. sam alignment file of the reads that mapped to the MAC genome (Cole_Pilot_001_S5_R1_001_unique_and_all_MAC.sam)
# 2. fastq file of reads that did not map to the MAC genome (failed_to_align_to_MAC_unique_and_all.fastq)
# 3. sam alignment file of reads that mapped to the MAC genome, using the reads that did not map to the MAC genome (Cole_Pilot_001_S5_R1_001_unique_and_all_MIC.sam)
# 4. fastq file of reads that did not mape the the MAC or the MIC genome (failed_to_align_to_MAC_and_MIC_unique_and_all)
# One, is a sam file of the reads that mapped to the 2014 MAC Tetrahymena thermophila genome (T_thermophila_June2014_assembly.fasta), the genome can be found at
# 'http://www.ciliate.org/system/downloads/T_thermophila_June2014_assembly.fasta' (104746 KB - 6/27/14). The reads that were kept were reads that uniquly    
# mapped to the genome (denoted by 'unique') as well as reads that mapped to multiple locations (denoted by 'and_all'). 
# Two, is a fastq file of the reads that did not align to the MAC genome, these reads are in no way modified from the original fastq file.
# Three, is a sam alignment file of the reads that did not map to the MAC genome but did map to the 2016 MIC Tetrahymena thermophila genome (T_thermophila_MIC_assembly.fasta)
# that can be found at 'http://www.ciliate.org/system/downloads/T_thermophila_MIC_assembly.fasta' (154761 KB - 12/7/16). Please note that the fastq file used to generate 
# output 3 is output 2.
# Four, is a fastq file of the reads that did not align to the MAC or MIC genomes, these reads are in no way modified from the original fastq file.


##PARAMETERS USED FOR BOWTIE2##
# -a (report all valid alignments, including multimapers)
# --very-sensitive-local (sets many settings to more optimally align smaller sequences, this also enables clipping/trimming from either end of the alignment if it 
#   betters the alignment score, supported by findings from Ziemann et al. 2016, --very-sensitive-local is the same as the options -D 20 -R 3 -N 0 -L 20 -i S,1,0.50)
# --phred33 (input fastq is phred 33 quality score encoded)
# --norc (the reads are forwardly stranded, do not not align the reverse complement (rc))
# --gbar 1 (one gap is allowed during alignment, i.e disallows gaps within 1 positions of the beginning or end of the read. Default: 4)
# --un failed_to_align.fastq (writes reads that failed to align to a fastq file, the reads are in no way modified from the original)
# --time (prints out the time taken to run the program)
# -x MAC_bt2_index_file (tells bowtie2 to use the indexed genome previously created)
# -U $fastq_input (input fastq filename)
# -S output.sam (output sam filename)
# |& tee txt unique_and_all_alignment_terminal_output.txt (this is a bash command to generate a txt file with a copy of the terminal output when bowtie was run)

fastq_input=$(echo "/media/pollardlab/POLLARDLAB3/cole_pilot_initial_analysis/step1_qc/Cole_Pilot_001_S5_R1_001_adapterTrim_polyATrim_qualityTrim_frontTrim_lenFilter.fastq")
MAC_genome_input=$(echo "T_thermophila_June2014_assembly.fasta")
MIC_genome_input=$(echo "T_thermophila_MIC_assembly.fasta")


echo "##### Creating indexes for genomes #####"
bowtie2-build $MAC_genome_input MAC_bt2_index_file
# the 'MAC_bt2_index_file' is the prefix for the index files that will be recognized by bowtie2 below
bowtie2-build $MIC_genome_input MIC_bt2_index_file
# the 'MIC_bt2_index_file' is the prefix for the index files that will be recognized by bowtie2 below
echo
echo


echo "##### Align to both genomes #####"
echo "## Generate alignment file for uniquly mapped reads and all multimapped reads to the MAC (may take a long time) ##"
bowtie2 -a --very-sensitive-local --phred33 --norc --gbar 1 --un failed_to_align_to_MAC_unique_and_all.fastq --time -x MAC_bt2_index_file -U $fastq_input -S Cole_Pilot_001_S5_R1_001_unique_and_all_MAC.sam |& tee unique_and_all_MAC_alignment_terminal_output.txt
echo
echo "## Generate alignment file for uniquly mapped reads and all multimapped reads to the MIC (may take a long time) ##"
bowtie2 -a --very-sensitive-local --phred33 --norc --gbar 1 --un failed_to_align_to_MIC_unique_and_all.fastq --time -x MIC_bt2_index_file -U $fastq_input -S Cole_Pilot_001_S5_R1_001_unique_and_all_MIC.sam |& tee unique_and_all_MIC_alignment_terminal_output.txt
echo
echo


echo "##### Take unaligned reads and align them to the other genome #####"
fastq_input_MAC_unaligned=$(echo "failed_to_align_to_MAC_unique_and_all.fastq")
fastq_input_MIC_unaligned=$(echo "failed_to_align_to_MIC_unique_and_all.fastq")
echo "## Take MAC unaligned reads and align them to the MIC ##"
bowtie2 -a --very-sensitive-local --phred33 --norc --gbar 1 --un failed_to_align_to_MAC_and_MIC_unique_and_all.fastq --time -x MIC_bt2_index_file -U $fastq_input_MAC_unaligned -S Cole_Pilot_001_S5_R1_001_unique_and_all_MIC_specific.sam |& tee unique_and_all_MIC_specific_alignment_terminal_output.txt
echo "## Take MIC unaligned reads and align them to the MAC ##"
bowtie2 -a --very-sensitive-local --phred33 --norc --gbar 1 --un failed_to_align_to_MIC_and_MAC_unique_and_all.fastq --time -x MAC_bt2_index_file -U $fastq_input_MIC_unaligned -S Cole_Pilot_001_S5_R1_001_unique_and_all_MAC_specific.sam |& tee unique_and_all_MAC_specific_alignment_terminal_output.txt
echo
echo

echo "## Moving indexed MIC and MIC genome files into folder for organization ##"
mkdir MIC_genome_index_files
mkdir MAC_genome_index_files
mv MIC_bt2_index_file* MIC_genome_index_files
mv MAC_bt2_index_file* MAC_genome_index_files

echo "## Moving terminal output files into folder for organization ##"
mkdir terminal_outputs
mv *.txt terminal_outputs

echo "Script Done."