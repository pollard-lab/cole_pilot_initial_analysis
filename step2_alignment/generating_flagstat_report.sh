#!/bin/bash

## DEPENDENCIES:
#PICARD (2.9.4)
#samtools (0.1.19)

#PICARD="$HOME/opt/picard-2.9.4.jar"

# make bam file from sam file
java -jar $PICARD SortSam I=Cole_Pilot_001_S5_R1_001_unique_and_all_MAC.sam O=Cole_Pilot_001_S5_R1_001_unique_and_all_MAC.bam SORT_ORDER=coordinate

# make the flagstat report from the bam file
samtools flagstat Cole_Pilot_001_S5_R1_001_unique_and_all_MAC.bam