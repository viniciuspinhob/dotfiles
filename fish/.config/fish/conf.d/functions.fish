# Fish Shell Functions

### Kubernetes Context Switcher ###
function kconf
    set -l contexts \
        "local:rancher-desktop" \
        "bruat:arn:aws:eks:us-east-1:020162860002:cluster/EKSDT-UAT-CLUSTER-V2" \
        "brprd:arn:aws:eks:sa-east-1:812128893680:cluster/EKSDT-PRD-CLUSTER-V2" \
        "ubuat:arn:aws:eks:us-east-1:222634392584:cluster/USBI-UAT-CLUSTER-DATA"

    if test (count $argv) -eq 0
        echo "Usage: kconf <context>"
        echo "Available contexts:"
        for ctx in $contexts
            set -l parts (string split ":" $ctx)
            echo "  $parts[1] - $parts[2]"
        end
        return 1
    end

    for ctx in $contexts
        set -l parts (string split ":" $ctx)
        if test "$parts[1]" = "$argv[1]"
            kubectl config use-context "$parts[2]"
            return 0
        end
    end

    echo "Unknown context: $argv[1]"
    return 1
end

### Spark Version Switcher ###
function vspark
    set -l versions \
        "331:$HOME/Developer/tools/spark-3.3.1-bin-hadoop3" \
        "351:$HOME/Developer/tools/spark-3.5.1-bin-hadoop3" \
        "353:$HOME/Developer/tools/spark-3.5.3-bin-hadoop3" \
        "356:$HOME/Developer/tools/spark-3.5.6-bin-hadoop3"

    if test (count $argv) -eq 0
        echo "Usage: vspark <version>"
        echo "Available Spark versions:"
        for ver in $versions
            set -l parts (string split ":" $ver)
            echo "  $parts[1] - $parts[2]"
        end
        return 1
    end

    for ver in $versions
        set -l parts (string split ":" $ver)
        if test "$parts[1]" = "$argv[1]"
            set -gx SPARK_HOME "$parts[2]"
            set -gx SPARK_LOCAL_IP "127.0.0.1"
            set -gx SPARK_DRIVER_HOST "127.0.0.1"
            set -gx PYSPARK_SUBMIT_ARGS "--driver-host 127.0.0.1 pyspark-shell"
            echo "Spark version set to: $argv[1] ($SPARK_HOME)"
            return 0
        end
    end

    echo "Unknown version: $argv[1]"
    return 1
end
