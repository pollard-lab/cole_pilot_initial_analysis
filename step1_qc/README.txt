Quality control steps were performed on the reads before they were used for analysis. All steps used cutadapt(1.16) and were followed by fastQC(v0.11.5).
All steps were performed by the bash script 'cole_pilot_qc.sh' and the cooresponding fastq files and fastQC reports were generated. The fastq files 
were not uploaded but the final fastq file ready for for the next step in the anlaysis would be named 'Cole_Pilot_001_S5_R1_001_adapterTrim_polyATrim_qualityTrim_frontTrim_lenFilter.fastq'.

The 'Cole_QC_terminal_output.txt' file shows the terminal output when 'cole_pilot_qc.sh' was run, and 'Cole_Pilot_001_S5_R1_001_fastqc.html' is the fastQC report on the original fastq before any quality control steps.
