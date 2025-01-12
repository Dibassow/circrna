include { SEGEMEHL_INDEX as INDEX   } from '../../../modules/nf-core/segemehl/index'
include { SEGEMEHL_ALIGN as ALIGN   } from '../../../modules/nf-core/segemehl/align'
include { GAWK as UNIFY             } from '../../../modules/nf-core/gawk'


workflow SEGEMEHL {
    take:
    reads
    fasta
    index

    main:
    ch_versions = Channel.empty()

    index = index ?: INDEX( fasta ).index
    ALIGN( reads, fasta, index )
    UNIFY( ALIGN.out.single_bed
        .map{ meta, bed ->  [ meta + [tool: "segemehl"], bed ] }, [] )

    ch_versions = ch_versions.mix(ALIGN.out.versions)
    ch_versions = ch_versions.mix(UNIFY.out.versions)

    emit:
    bed = UNIFY.out.output

    versions = ch_versions
}
