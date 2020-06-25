version 1.0
import "haplotype_caller_subworkflow" as sub

workflow main {

  input{
    File input_bam
    File ref_dict
    File ref_fasta
    File ref_fasta_index
    File interval1
    File interval2
    File interval3
    File interval4
    File interval5
    File interval6
    File interval7
    File interval8
    File interval9
    File interval10
  }

  call sub.HaplotypeCallerGvcf_GATK4{
    input:
      input_bam = input_bam,
      ref_dict = ref_dict,
      ref_fasta = ref_fasta,
      ref_fasta_index = ref_fasta_index,
      interval1 = interval1,
      interval2 = interval2,
      interval3 = interval3,
      interval4 = interval4,
      interval5 = interval5,
      interval6 = interval6,
      interval7 = interval7,
      interval8 = interval8,
      interval9 = interval9,
      interval10 = interval10
  }

  output{
    File output_vcf = HaplotypeCallerGvcf_GATK4.output_vcf
    File output_vcf_index = HaplotypeCallerGvcf_GATK4.output_vcf_index
  }
}
