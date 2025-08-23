### Functions ###

# Kubernetes Contexts
typeset -A kconf_contexts
kconf_contexts=(
    [local]="rancher-desktop"
    [bruat]="arn:aws:eks:us-east-1:020162860002:cluster/EKSDT-UAT-CLUSTER-V2"
    [brprd]="arn:aws:eks:sa-east-1:812128893680:cluster/EKSDT-PRD-CLUSTER-V2"
    [ubuat]="arn:aws:eks:us-east-1:222634392584:cluster/USBI-UAT-CLUSTER-DATA"
)
kconf() {
    if [[ -n "${kconf_contexts[$1]}" ]]; then
        kubectl config use-context "${kconf_contexts[$1]}"
    else
        echo "Usage: kconf <context>"
        echo "Available contexts:"
        for context in ${(k)kconf_contexts}; do
            echo "  $context - ${kconf_contexts[$context]}"
        done
        return 1
    fi
}

# Spark
export SPARK_HOME="~/Developer/tools/spark-3.5.1-bin-hadoop3"
typeset -A spark_versions
spark_versions=(
    [331]="$HOME/Developer/tools/spark-3.3.1-bin-hadoop3"
    [351]="$HOME/Developer/tools/spark-3.5.1-bin-hadoop3"
    [353]="$HOME/Developer/tools/spark-3.5.3-bin-hadoop3"
    [356]="$HOME/Developer/tools/spark-3.5.6-bin-hadoop3"
)
vspark() {
    if [[ -n "${spark_versions[$1]}" ]]; then
        export SPARK_HOME="${spark_versions[$1]}"
        echo "Spark version set to: $1 ($SPARK_HOME)"
    else
        echo "Usage: vspark <version>"
        echo "Available Spark versions:"
        for version in ${(k)spark_versions}; do
            echo "  $version - ${spark_versions[$version]}"
        done
        return 1
    fi
}
