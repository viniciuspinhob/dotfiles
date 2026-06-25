#!/bin/bash

asdf --version

# PYTHON
asdf plugin add python
PYTHON_VERSION="3.14.6"
asdf install python "$PYTHON_VERSION"
asdf set -u python "$PYTHON_VERSION"

# JAVA
asdf plugin add java 2>/dev/null || true
JAVA_VERSION="openjdk-17.0.2"
asdf install java "$JAVA_VERSION"
asdf set -u java "$JAVA_VERSION"

# APACHE SPARK
asdf plugin add spark
SPARK_VERSION="3.5.3"
asdf install spark "$SPARK_VERSION"
asdf set -u spark "$SPARK_VERSION"

