version 1.0

## Inputs:
## - List of input CRAM files
## - Reference Genome, Dictionary, and Index
## - Target intervals list
##
## Outputs :
## - One GVCF file and its index

# WORKFLOW DEFINITION
workflow Cram2GVCF {
  input {
    Boolean make_gvcf = true
    Boolean make_bamout = false
    String gatk_docker = "broadinstitute/gatk:4.1.7.0"
    String gatk_path = "/gatk/gatk"
    String gitc_docker = "broadinstitute/genomes-in-the-cloud:2.3.1-1500064817"
    String samtools_path = "samtools"
  }

  File input_cram0
  File input_cram1
  File input_cram2
  File input_cram3
  File input_cram4
  File input_cram5
  File input_cram6
  File input_cram7
  File input_cram8
  File input_cram9
  File ref_dict
  File ref_fasta
  File ref_fasta_index
  File intervals

  # Get basenames
  String sample_basename0 = basename(input_cram0, ".cram")
  String sample_basename1 = basename(input_cram1, ".cram")
  String sample_basename2 = basename(input_cram2, ".cram")
  String sample_basename3 = basename(input_cram3, ".cram")
  String sample_basename4 = basename(input_cram4, ".cram")
  String sample_basename5 = basename(input_cram5, ".cram")
  String sample_basename6 = basename(input_cram6, ".cram")
  String sample_basename7 = basename(input_cram7, ".cram")
  String sample_basename8 = basename(input_cram8, ".cram")
  String sample_basename9 = basename(input_cram9, ".cram")
  String vcf_basename0 = sample_basename0
  String vcf_basename1 = sample_basename1
  String vcf_basename2 = sample_basename2
  String vcf_basename3 = sample_basename3
  String vcf_basename4 = sample_basename4
  String vcf_basename5 = sample_basename5
  String vcf_basename6 = sample_basename6
  String vcf_basename7 = sample_basename7
  String vcf_basename8 = sample_basename8
  String vcf_basename9 = sample_basename9
  String output_filename0 = vcf_basename0 + ".g.vcf.gz"
  String output_filename1 = vcf_basename1 + ".g.vcf.gz"
  String output_filename2 = vcf_basename2 + ".g.vcf.gz"
  String output_filename3 = vcf_basename3 + ".g.vcf.gz"
  String output_filename4 = vcf_basename4 + ".g.vcf.gz"
  String output_filename5 = vcf_basename5 + ".g.vcf.gz"
  String output_filename6 = vcf_basename6 + ".g.vcf.gz"
  String output_filename7 = vcf_basename7 + ".g.vcf.gz"
  String output_filename8 = vcf_basename8 + ".g.vcf.gz"
  String output_filename9 = vcf_basename9 + ".g.vcf.gz"

  # CRAM to BAM and adjust BAM header
  call CramToBamTask {
    input:
      input_cram0 = input_cram0,
      input_cram1 = input_cram1,
      input_cram2 = input_cram2,
      input_cram3 = input_cram3,
      input_cram4 = input_cram4,
      input_cram5 = input_cram5,
      input_cram6 = input_cram6,
      input_cram7 = input_cram7,
      input_cram8 = input_cram8,
      input_cram9 = input_cram9,
      sample_name0 = sample_basename0,
      sample_name1 = sample_basename1,
      sample_name2 = sample_basename2,
      sample_name3 = sample_basename3,
      sample_name4 = sample_basename4,
      sample_name5 = sample_basename5,
      sample_name6 = sample_basename6,
      sample_name7 = sample_basename7,
      sample_name8 = sample_basename8,
      sample_name9 = sample_basename9,
      ref_dict = ref_dict,
      ref_fasta = ref_fasta,
      ref_fasta_index = ref_fasta_index,
      docker = gitc_docker,
      samtools_path = samtools_path
  }
  # Generate GVCF by interval
  call HaplotypeCaller {
    input:
      input_bam0 = CramToBamTask.output_bam0,
      input_bam1 = CramToBamTask.output_bam1,
      input_bam2 = CramToBamTask.output_bam2,
      input_bam3 = CramToBamTask.output_bam3,
      input_bam4 = CramToBamTask.output_bam4,
      input_bam5 = CramToBamTask.output_bam5,
      input_bam6 = CramToBamTask.output_bam6,
      input_bam7 = CramToBamTask.output_bam7,
      input_bam8 = CramToBamTask.output_bam8,
      input_bam9 = CramToBamTask.output_bam9,
      input_bam_index0 = CramToBamTask.output_bai0,
      input_bam_index1 = CramToBamTask.output_bai1,
      input_bam_index2 = CramToBamTask.output_bai2,
      input_bam_index3 = CramToBamTask.output_bai3,
      input_bam_index4 = CramToBamTask.output_bai4,
      input_bam_index5 = CramToBamTask.output_bai5,
      input_bam_index6 = CramToBamTask.output_bai6,
      input_bam_index7 = CramToBamTask.output_bai7,
      input_bam_index8 = CramToBamTask.output_bai8,
      input_bam_index9 = CramToBamTask.output_bai9,
      interval_list = intervals,
      output_filename0 = output_filename0,
      output_filename1 = output_filename1,
      output_filename2 = output_filename2,
      output_filename3 = output_filename3,
      output_filename4 = output_filename4,
      output_filename5 = output_filename5,
      output_filename6 = output_filename6,
      output_filename7 = output_filename7,
      output_filename8 = output_filename8,
      output_filename9 = output_filename9,
      ref_dict = ref_dict,
      ref_fasta = ref_fasta,
      ref_fasta_index = ref_fasta_index,
      make_gvcf = make_gvcf,
      make_bamout = make_bamout,
      docker = gatk_docker,
      gatk_path = gatk_path
  }

  # Outputs that will be retained when execution is complete
  output {
    Array[File] output_gvcf = HaplotypeCaller.output_gvcf
    Array[File] output_gvcf_index = HaplotypeCaller.output_gvcf_index
  }
}

# TASK DEFINITIONS
task CramToBamTask {
  input {
    # Command parameters
    File ref_fasta
    File ref_fasta_index
    File ref_dict
    File input_cram0
    File input_cram1
    File input_cram2
    File input_cram3
    File input_cram4
    File input_cram5
    File input_cram6
    File input_cram7
    File input_cram8
    File input_cram9
    String sample_name0
    String sample_name1
    String sample_name2
    String sample_name3
    String sample_name4
    String sample_name5
    String sample_name6
    String sample_name7
    String sample_name8
    String sample_name9

    # Runtime parameters
    String docker
    String samtools_path
  }

  # Determine disk size
  Float input_cram_size = size(input_cram0, "GB") + size(input_cram1, "GB") + size(input_cram2, "GB") + size(input_cram3, "GB") + size(input_cram4, "GB") + size(input_cram5, "GB") + size(input_cram7, "GB") + size(input_cram7, "GB") + size(input_cram8, "GB") + size(input_cram9, "GB")
  Float output_bam_size = size(input_cram0, "GB") / 0.60 + size(input_cram1, "GB") / 0.60 + size(input_cram2, "GB") / 0.60 + size(input_cram3, "GB") / 0.60 + size(input_cram4, "GB") / 0.60 + size(input_cram5, "GB") / 0.60 + size(input_cram6, "GB") / 0.60 + size(input_cram7, "GB") / 0.60 + size(input_cram8, "GB") / 0.60 + size(input_cram9, "GB") / 0.60
  Float ref_size = size(ref_fasta, "GB") + size(ref_fasta_index, "GB") + size(ref_dict, "GB")
  Int disk_size = ceil(input_cram_size + output_bam_size + ref_size) + 20

  command {
    set -e
    set -o pipefail


    ~{samtools_path} view -H ~{input_cram0} | \
    sed -e '/^@SQ/s/SN\:/SN\:chr/' -e '/^[^@]/s/\t/\tchr/2' > ~{sample_name0}.fixed_header.txt
    ~{samtools_path} reheader ~{sample_name0}.fixed_header.txt ~{input_cram0} > ~{sample_name0}.fixed.cram
    ~{samtools_path} view -h -T ~{ref_fasta} ~{sample_name0}.fixed.cram |
    ~{samtools_path} view -b -o ~{sample_name0}.bam -
    ~{samtools_path} index -b ~{sample_name0}.bam
    mv ~{sample_name0}.bam.bai ~{sample_name0}.bai

    ~{samtools_path} view -H ~{input_cram1} | \
    sed -e '/^@SQ/s/SN\:/SN\:chr/' -e '/^[^@]/s/\t/\tchr/2' > ~{sample_name1}.fixed_header.txt
    ~{samtools_path} reheader ~{sample_name1}.fixed_header.txt ~{input_cram1} > ~{sample_name1}.fixed.cram
    ~{samtools_path} view -h -T ~{ref_fasta} ~{sample_name1}.fixed.cram |
    ~{samtools_path} view -b -o ~{sample_name1}.bam -
    ~{samtools_path} index -b ~{sample_name1}.bam
    mv ~{sample_name1}.bam.bai ~{sample_name1}.bai

    ~{samtools_path} view -H ~{input_cram2} | \
    sed -e '/^@SQ/s/SN\:/SN\:chr/' -e '/^[^@]/s/\t/\tchr/2' > ~{sample_name2}.fixed_header.txt
    ~{samtools_path} reheader ~{sample_name2}.fixed_header.txt ~{input_cram2} > ~{sample_name2}.fixed.cram
    ~{samtools_path} view -h -T ~{ref_fasta} ~{sample_name2}.fixed.cram |
    ~{samtools_path} view -b -o ~{sample_name2}.bam -
    ~{samtools_path} index -b ~{sample_name2}.bam
    mv ~{sample_name2}.bam.bai ~{sample_name2}.bai

    ~{samtools_path} view -H ~{input_cram3} | \
    sed -e '/^@SQ/s/SN\:/SN\:chr/' -e '/^[^@]/s/\t/\tchr/2' > ~{sample_name3}.fixed_header.txt
    ~{samtools_path} reheader ~{sample_name3}.fixed_header.txt ~{input_cram3} > ~{sample_name3}.fixed.cram
    ~{samtools_path} view -h -T ~{ref_fasta} ~{sample_name3}.fixed.cram |
    ~{samtools_path} view -b -o ~{sample_name3}.bam -
    ~{samtools_path} index -b ~{sample_name3}.bam
    mv ~{sample_name3}.bam.bai ~{sample_name3}.bai

    ~{samtools_path} view -H ~{input_cram4} | \
    sed -e '/^@SQ/s/SN\:/SN\:chr/' -e '/^[^@]/s/\t/\tchr/2' > ~{sample_name4}.fixed_header.txt
    ~{samtools_path} reheader ~{sample_name4}.fixed_header.txt ~{input_cram4} > ~{sample_name4}.fixed.cram
    ~{samtools_path} view -h -T ~{ref_fasta} ~{sample_name4}.fixed.cram |
    ~{samtools_path} view -b -o ~{sample_name4}.bam -
    ~{samtools_path} index -b ~{sample_name4}.bam
    mv ~{sample_name4}.bam.bai ~{sample_name4}.bai

    ~{samtools_path} view -H ~{input_cram5} | \
    sed -e '/^@SQ/s/SN\:/SN\:chr/' -e '/^[^@]/s/\t/\tchr/2' > ~{sample_name5}.fixed_header.txt
    ~{samtools_path} reheader ~{sample_name5}.fixed_header.txt ~{input_cram5} > ~{sample_name5}.fixed.cram
    ~{samtools_path} view -h -T ~{ref_fasta} ~{sample_name5}.fixed.cram |
    ~{samtools_path} view -b -o ~{sample_name5}.bam -
    ~{samtools_path} index -b ~{sample_name5}.bam
    mv ~{sample_name5}.bam.bai ~{sample_name5}.bai

    ~{samtools_path} view -H ~{input_cram6} | \
    sed -e '/^@SQ/s/SN\:/SN\:chr/' -e '/^[^@]/s/\t/\tchr/2' > ~{sample_name6}.fixed_header.txt
    ~{samtools_path} reheader ~{sample_name6}.fixed_header.txt ~{input_cram6} > ~{sample_name6}.fixed.cram
    ~{samtools_path} view -h -T ~{ref_fasta} ~{sample_name6}.fixed.cram |
    ~{samtools_path} view -b -o ~{sample_name6}.bam -
    ~{samtools_path} index -b ~{sample_name6}.bam
    mv ~{sample_name6}.bam.bai ~{sample_name6}.bai

    ~{samtools_path} view -H ~{input_cram7} | \
    sed -e '/^@SQ/s/SN\:/SN\:chr/' -e '/^[^@]/s/\t/\tchr/2' > ~{sample_name7}.fixed_header.txt
    ~{samtools_path} reheader ~{sample_name7}.fixed_header.txt ~{input_cram7} > ~{sample_name7}.fixed.cram
    ~{samtools_path} view -h -T ~{ref_fasta} ~{sample_name7}.fixed.cram |
    ~{samtools_path} view -b -o ~{sample_name7}.bam -
    ~{samtools_path} index -b ~{sample_name7}.bam
    mv ~{sample_name7}.bam.bai ~{sample_name7}.bai

    ~{samtools_path} view -H ~{input_cram8} | \
    sed -e '/^@SQ/s/SN\:/SN\:chr/' -e '/^[^@]/s/\t/\tchr/2' > ~{sample_name8}.fixed_header.txt
    ~{samtools_path} reheader ~{sample_name8}.fixed_header.txt ~{input_cram8} > ~{sample_name8}.fixed.cram
    ~{samtools_path} view -h -T ~{ref_fasta} ~{sample_name8}.fixed.cram |
    ~{samtools_path} view -b -o ~{sample_name8}.bam -
    ~{samtools_path} index -b ~{sample_name8}.bam
    mv ~{sample_name8}.bam.bai ~{sample_name8}.bai

    ~{samtools_path} view -H ~{input_cram9} | \
    sed -e '/^@SQ/s/SN\:/SN\:chr/' -e '/^[^@]/s/\t/\tchr/2' > ~{sample_name9}.fixed_header.txt
    ~{samtools_path} reheader ~{sample_name9}.fixed_header.txt ~{input_cram9} > ~{sample_name9}.fixed.cram
    ~{samtools_path} view -h -T ~{ref_fasta} ~{sample_name9}.fixed.cram |
    ~{samtools_path} view -b -o ~{sample_name9}.bam -
    ~{samtools_path} index -b ~{sample_name9}.bam
    mv ~{sample_name9}.bam.bai ~{sample_name9}.bai
  }
  runtime {
    docker: docker
    memory: "8 GB" # Changed to static value for testing
    disk: disk_size + " GB"
    cpu: 1
    preemptible: true
    maxRetries: 3
 }
  output {
    File output_bam0 = "~{sample_name0}.bam"
    File output_bam1 = "~{sample_name1}.bam"
    File output_bam2 = "~{sample_name2}.bam"
    File output_bam3 = "~{sample_name3}.bam"
    File output_bam4 = "~{sample_name4}.bam"
    File output_bam5 = "~{sample_name5}.bam"
    File output_bam6 = "~{sample_name6}.bam"
    File output_bam7 = "~{sample_name7}.bam"
    File output_bam8 = "~{sample_name8}.bam"
    File output_bam9 = "~{sample_name9}.bam"
    File output_bai0 = "~{sample_name0}.bai"
    File output_bai1 = "~{sample_name1}.bai"
    File output_bai2 = "~{sample_name2}.bai"
    File output_bai3 = "~{sample_name3}.bai"
    File output_bai4 = "~{sample_name4}.bai"
    File output_bai5 = "~{sample_name5}.bai"
    File output_bai6 = "~{sample_name6}.bai"
    File output_bai7 = "~{sample_name7}.bai"
    File output_bai8 = "~{sample_name8}.bai"
    File output_bai9 = "~{sample_name9}.bai"
  }
}

# HaplotypeCaller per-sample in GVCF mode
task HaplotypeCaller {
  input {
    # Command parameters
    File input_bam0
    File input_bam1
    File input_bam2
    File input_bam3
    File input_bam4
    File input_bam5
    File input_bam6
    File input_bam7
    File input_bam8
    File input_bam9
    File input_bam_index0
    File input_bam_index1
    File input_bam_index2
    File input_bam_index3
    File input_bam_index4
    File input_bam_index5
    File input_bam_index6
    File input_bam_index7
    File input_bam_index8
    File input_bam_index9
    String output_filename0
    String output_filename1
    String output_filename2
    String output_filename3
    String output_filename4
    String output_filename5
    String output_filename6
    String output_filename7
    String output_filename8
    String output_filename9
    File interval_list
    File ref_dict
    File ref_fasta
    File ref_fasta_index
    Float? contamination
    Boolean make_gvcf
    Boolean make_bamout

    String gatk_path
    String? java_options

    # Runtime parameters
    String docker
  }

  String java_opt = select_first([java_options, "-XX:GCTimeLimit=50 -XX:GCHeapFreeLimit=10"])

  # Get Disk Size
  Float input_bam_size = size(input_bam0, "GB") + size(input_bam1, "GB") + size(input_bam2, "GB") + size(input_bam3, "GB") + size(input_bam4, "GB") + size(input_bam5, "GB") + size(input_bam7, "GB") + size(input_bam7, "GB") + size(input_bam8, "GB") + size(input_bam9, "GB")
  Float ref_size = size(ref_fasta, "GB") + size(ref_fasta_index, "GB") + size(ref_dict, "GB")
  Int disk_size = ceil((input_bam_size + 30) + ref_size) + 20

  command {
    set -e
    ~{gatk_path} --java-options "-Xmx6G ~{java_opt}" \
      HaplotypeCaller \
      -R ~{ref_fasta} \
      -I ~{input_bam0} \
      -L ~{interval_list} \
      -O ~{output_filename0} \
      -contamination ~{default=0 contamination} \
      -G StandardAnnotation -G StandardHCAnnotation ~{true="-G AS_StandardAnnotation" false="" make_gvcf} \
      -GQB 10 -GQB 20 -GQB 30 -GQB 40 -GQB 50 -GQB 60 -GQB 70 -GQB 80 -GQB 90 \
      ~{true="-ERC GVCF" false="" make_gvcf}

    ~{gatk_path} --java-options "-Xmx6G ~{java_opt}" \
      HaplotypeCaller \
      -R ~{ref_fasta} \
      -I ~{input_bam1} \
      -L ~{interval_list} \
      -O ~{output_filename1} \
      -contamination ~{default=0 contamination} \
      -G StandardAnnotation -G StandardHCAnnotation ~{true="-G AS_StandardAnnotation" false="" make_gvcf} \
      -GQB 10 -GQB 20 -GQB 30 -GQB 40 -GQB 50 -GQB 60 -GQB 70 -GQB 80 -GQB 90 \
      ~{true="-ERC GVCF" false="" make_gvcf}

    ~{gatk_path} --java-options "-Xmx6G ~{java_opt}" \
      HaplotypeCaller \
      -R ~{ref_fasta} \
      -I ~{input_bam2} \
      -L ~{interval_list} \
      -O ~{output_filename2} \
      -contamination ~{default=0 contamination} \
      -G StandardAnnotation -G StandardHCAnnotation ~{true="-G AS_StandardAnnotation" false="" make_gvcf} \
      -GQB 10 -GQB 20 -GQB 30 -GQB 40 -GQB 50 -GQB 60 -GQB 70 -GQB 80 -GQB 90 \
      ~{true="-ERC GVCF" false="" make_gvcf}

    ~{gatk_path} --java-options "-Xmx6G ~{java_opt}" \
      HaplotypeCaller \
      -R ~{ref_fasta} \
      -I ~{input_bam3} \
      -L ~{interval_list} \
      -O ~{output_filename3} \
      -contamination ~{default=0 contamination} \
      -G StandardAnnotation -G StandardHCAnnotation ~{true="-G AS_StandardAnnotation" false="" make_gvcf} \
      -GQB 10 -GQB 20 -GQB 30 -GQB 40 -GQB 50 -GQB 60 -GQB 70 -GQB 80 -GQB 90 \
      ~{true="-ERC GVCF" false="" make_gvcf}

    ~{gatk_path} --java-options "-Xmx6G ~{java_opt}" \
      HaplotypeCaller \
      -R ~{ref_fasta} \
      -I ~{input_bam4} \
      -L ~{interval_list} \
      -O ~{output_filename4} \
      -contamination ~{default=0 contamination} \
      -G StandardAnnotation -G StandardHCAnnotation ~{true="-G AS_StandardAnnotation" false="" make_gvcf} \
      -GQB 10 -GQB 20 -GQB 30 -GQB 40 -GQB 50 -GQB 60 -GQB 70 -GQB 80 -GQB 90 \
      ~{true="-ERC GVCF" false="" make_gvcf}

    ~{gatk_path} --java-options "-Xmx6G ~{java_opt}" \
      HaplotypeCaller \
      -R ~{ref_fasta} \
      -I ~{input_bam5} \
      -L ~{interval_list} \
      -O ~{output_filename5} \
      -contamination ~{default=0 contamination} \
      -G StandardAnnotation -G StandardHCAnnotation ~{true="-G AS_StandardAnnotation" false="" make_gvcf} \
      -GQB 10 -GQB 20 -GQB 30 -GQB 40 -GQB 50 -GQB 60 -GQB 70 -GQB 80 -GQB 90 \
      ~{true="-ERC GVCF" false="" make_gvcf}

   ~{gatk_path} --java-options "-Xmx6G ~{java_opt}" \
      HaplotypeCaller \
      -R ~{ref_fasta} \
      -I ~{input_bam6} \
      -L ~{interval_list} \
      -O ~{output_filename6} \
      -contamination ~{default=0 contamination} \
      -G StandardAnnotation -G StandardHCAnnotation ~{true="-G AS_StandardAnnotation" false="" make_gvcf} \
      -GQB 10 -GQB 20 -GQB 30 -GQB 40 -GQB 50 -GQB 60 -GQB 70 -GQB 80 -GQB 90 \
      ~{true="-ERC GVCF" false="" make_gvcf}

      ~{gatk_path} --java-options "-Xmx6G ~{java_opt}" \
        HaplotypeCaller \
        -R ~{ref_fasta} \
        -I ~{input_bam7} \
        -L ~{interval_list} \
        -O ~{output_filename7} \
        -contamination ~{default=0 contamination} \
        -G StandardAnnotation -G StandardHCAnnotation ~{true="-G AS_StandardAnnotation" false="" make_gvcf} \
        -GQB 10 -GQB 20 -GQB 30 -GQB 40 -GQB 50 -GQB 60 -GQB 70 -GQB 80 -GQB 90 \
        ~{true="-ERC GVCF" false="" make_gvcf}

      ~{gatk_path} --java-options "-Xmx6G ~{java_opt}" \
        HaplotypeCaller \
        -R ~{ref_fasta} \
        -I ~{input_bam8} \
        -L ~{interval_list} \
        -O ~{output_filename8} \
        -contamination ~{default=0 contamination} \
        -G StandardAnnotation -G StandardHCAnnotation ~{true="-G AS_StandardAnnotation" false="" make_gvcf} \
        -GQB 10 -GQB 20 -GQB 30 -GQB 40 -GQB 50 -GQB 60 -GQB 70 -GQB 80 -GQB 90 \
        ~{true="-ERC GVCF" false="" make_gvcf}

      ~{gatk_path} --java-options "-Xmx6G ~{java_opt}" \
        HaplotypeCaller \
        -R ~{ref_fasta} \
        -I ~{input_bam9} \
        -L ~{interval_list} \
        -O ~{output_filename9} \
        -contamination ~{default=0 contamination} \
        -G StandardAnnotation -G StandardHCAnnotation ~{true="-G AS_StandardAnnotation" false="" make_gvcf} \
        -GQB 10 -GQB 20 -GQB 30 -GQB 40 -GQB 50 -GQB 60 -GQB 70 -GQB 80 -GQB 90 \
        ~{true="-ERC GVCF" false="" make_gvcf}
  }
  runtime {
    docker: docker
    memory: "8 GB" # Changed to static value for testing
    disk: disk_size + " GB" # Changed to static value for testing
    cpu: 1
    preemptible: true
    maxRetries: 3
  }
  output {
    Array[File] output_gvcf = ["~{output_filename0}", "~{output_filename1}", "~{output_filename2}", "~{output_filename3}", "~{output_filename4}", "~{output_filename5}", "~{output_filename6}", "~{output_filename7}", "~{output_filename8}", "~{output_filename9}"]
    Array[File] output_gvcf_index = ["~{output_filename0}.tbi", "~{output_filename1}.tbi", "~{output_filename2}.tbi", "~{output_filename3}.tbi", "~{output_filename4}.tbi", "~{output_filename5}.tbi", "~{output_filename6}.tbi", "~{output_filename7}.tbi", "~{output_filename8}.tbi", "~{output_filename9}.tbi"]
  }
}
