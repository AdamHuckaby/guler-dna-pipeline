# guler-dna-pipeline
DNA processing pipeline for Jennfier Guler's Biology Lab at UVA

See `dependencies.md` for installation instructions. Repo supports 64-bit Linux and MacOS only.

## Task List

+ Import DNA sequence reads and create consistent name conventions. Currently ~150 genomes in fastq format. `report_gen.R` is our current best attempt at this. Works in sample `fastq.gz` files in this repository, but not all we have access to. The `fast.qz` files are stored on Adam's machine only at the moment.

+ Quality control on reads, FastQC.

+ Align reads using BWA-MEM to create sam/bam files. Recommended settings command is: `bwa mem ref.fa read1.fq read2.fq > aln-pe.sam`

+ Use CNVnator to analyze bam files

+ Use Delly2 to analyze bam files

+ Compare CNV breakpoint locations from CNVnator to locations from Delly2 and extract sequences at breakpoints for further analysis


### Collecting Data from `fastq.gz` Files

Given `clinical_data/` directory containing `.fastq.gz` files:  
Rscript report_gen.R ~/Desktop/guler-lab/clinical_data/

Make sure to use the absolute path to the directory.

