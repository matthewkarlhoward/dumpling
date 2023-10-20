rule generate_enrich_config:
    """Generate an Enrich2 configuration file based on experimental config."""
    output:
        "results/{experiment_name}/enrich/{experiment_name}_config.json"
    benchmark:
        "benchmarks/{experiment_name}/{experiment_name}.generate_enrich_config.benchmark.txt"
    log:
        "logs/{experiment_name}/scripts/{experiment_name}.generate_enrich_config.log",
    script:
        "scripts/generate_enrich_configs.py"

rule run_enrich:
    """Run Enrich2 on the final filtered read counts."""
    input:
        expand(
            "results/{{experiment_name}}/processed_counts/{samples}.tsv",
            samples=samples
        ),
        config="results/{experiment_name}/enrich/{experiment_name}_config.json",
    output:
        "results/{experiment_name}/enrich/tsv/{experiment_name}_exp/main_identifiers_scores.tsv",
    benchmark:
        "benchmarks/{experiment_name}/{experiment_name}.enrich.benchmark.txt"
    log:
        "logs/{experiment_name}/enrich/{experiment_name}.enrich.log"
    conda:
        "../envs/enrich.yaml"
    shell:
        "enrich_cmd --log {log} --no-plots --recalculate "
        "{input.config} WLS full"


        