FASTQ_FILES=$(find $1 -name *.fastq)
echo $FASTQ_FILES
OUTPUT=fastqc_results
mkdir -p $OUTPUT
for file in $FASTQ_FILES
do
    echo $file
    fastqc -t 5 $file -o $OUTPUT
done