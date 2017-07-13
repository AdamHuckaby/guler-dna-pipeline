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

###download DSM1 files using SRA, may have to change the path for your installation of sratoolkit
 /home/ahuckaby/sratoolkit.2.8.2-1-centos_linux64/bin/fastq-dump --split-files SRR941237
 /home/ahuckaby/sratoolkit.2.8.2-1-centos_linux64/bin/fastq-dump --split-files SRR941239
 /home/ahuckaby/sratoolkit.2.8.2-1-centos_linux64/bin/fastq-dump --split-files SRR941241

###rename 37 to D731, 39 to Dd2, and 41 to C710
###replace all ".1 " with "/1 " etc
sed -i -- 's\.1 \/1 \g' *
sed -i -- 's\.2 \/2 \g' *
sed -i -- 's\.3 \/2 \g' *

###interleave reads, trim white space, and compress
reformat.sh in=Dd2_1.fastq in2=Dd2_2.fastq out=Dd2_interleaved.fastq.gz trd
reformat.sh in=C710_1.fastq in2=C710_2.fastq out=C710_interleaved.fastq.gz trd
reformat.sh in=D731_1.fastq in2=D731_2.fastq out=D731_interleaved.fastq.gz trd

###run QC on reads as necessary using bbtools

##use speedseq to align, could add in qualifiers to keep names consistent and run all at once in the future
speedseq align -p -v -t 4 -o Dd2align -M 3 -R "@RG\tID:Dd2.s1\tSM:CGATGT\tLB:lib1" /home/ahuckaby/genomes/Pfal/PlasmoDB-31_Pfalciparum3D7_Genome.fasta /home/ahuckaby/Desktop/DSM1/Dd2_interleaved.fastq.gz

speedseq align -p -v -t 4 -o C710align -M 3 -R "@RG\tID:C710.s1\tSM:CGATGT\tLB:lib2" /home/ahuckaby/genomes/Pfal/PlasmoDB-31_Pfalciparum3D7_Genome.fasta /home/ahuckaby/Desktop/DSM1/C710_interleaved.fastq.gz

speedseq align -p -v -t 4 -o D731test -M 3 -R "@RG\tID:D731a.s1\tSM:CGATGT\tLB:lib3" /home/ahuckaby/genomes/Pfal/PlasmoDB-31_Pfalciparum3D7_Genome.fasta /home/ahuckaby/Desktop/DSM1/D731_interleaved.fastq.gz
