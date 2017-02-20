# guler-lab
Professor Jennifer Guler's Biology Lab of UVA

Link to bedtools https://github.com/arq5x/bedtools
Link to bedtools2 https://github.com/arq5x/bedtools2
Link to FastQC http://www.bioinformatics.babraham.ac.uk/projects/fastqc/
Link to BWA https://github.com/lh3/bwa
Link to Delly2 https://github.com/dellytools/delly

## Task List

+ Import DNA sequence reads and create consistent name conventions
+ Currently ~150 genomes in fastq format

+ Quality control on reads, FastQC
+ Utilizes Java, Perl, and Shell

+ Align reads using BWA-MEM to create sam/bam files
+ Recommended settings command is: bwa mem ref.fa read1.fq read2.fq > aln-pe.sam
+ Utilizes C, C++, Java, Shell, Perl, makefile, other 

+ Use CNVnator to analyze bam files
+ Utilizes C++, PERL, makefile

+ Use Delly2 to analyze bam files
+ Utilizes C++ and makefile

+ Compare CNV breakpoint locations from CNVnator to locations from Delly2 and extract sequences at breakpoints for further analysis

+ Organize directories to make OS/path-independent. Chris.

+ Develop standard method of reading .bed files with data.table.

+ Cut `bedtools` terminal command out of the picture.
