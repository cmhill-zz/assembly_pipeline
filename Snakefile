"""
Assembly analysis for a PacBio assembly.

"""
import math
import os

# Always source config file.
SNAKEMAKE_DIR = os.path.dirname(workflow.snakefile)
shell.prefix(". {SNAKEMAKE_DIR}/config.sh; ")

#
# Define internal constants.
#
BLASR_BIN = "/net/eichler/vol20/projects/pacbio/nobackups/users/jlhudd/blasr_jlhudd/alignment/bin/blasr"
CWD = os.getcwd()

#
# Load user variables.
#
configfile: "config.json"
TMP_DIR = config["tmp_dir"]
#EVENT_TYPES = ("insertion", "deletion")

#CHROMOSOME_LENGTHS = config.get("reference_index", "%s.fai" % config["reference"])

#
# Include rules.
#

# TODO: fix bug caused by Snakemake not understanding more than one dynamic
# output type per file.
include: "rules/whole_genome_comparisons.rules"
include: "rules/quiver.rules"
include: "rules/repeat_masker.rules"

# Only include alignment rules if alignments aren't defined already or don't
# exist yet.
#if config.get("alignments") is None or not os.path.exists(config.get("alignments")):
#    include: "rules/alignment.rules"

#include: "rules/sv_candidates.rules"
#include: "rules/local_assembly.mhap_celera.rules"
#include: "rules/variant_caller.rules"

#
# Determine which outputs to create.
#
OUTPUTS = []

if config.get("whole_genome_comparisons"):
    OUTPUTS.extend([
        "whole_genome_comparisons/assembly_vs_GRCh38.mummerplot.png",
        config["assembly"]["quivered"]
    ])


# if config.get("assembly") and config["assembly"].get("regions_to_assemble"):
#     OUTPUTS.append("sv_assemblies.txt")

# if config.get("gap_extension") and config["gap_extension"].get("regions_to_assemble"):
#     OUTPUTS.append("gap_assemblies.txt")

#
# Define rules.
#

# Create list of all final outputs.
rule all:
    input: OUTPUTS
