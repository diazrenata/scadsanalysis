How to run
================

# Installations

You will need to download and install hte package for this research
compendium, as well as packages to run the analytical workflow and
optionally HPC.

``` r
devtools::install_github("diazrenata/scadsanalysis@clean-and-tests")
install.packages("drake")
install.packages("DBI")
install.packages("storr")
install.packages("clustermq")
```

``` r
library(scadsanalysis)
```

# Download and prep data

``` r
download_data()
```

# Get the p tables

Either copy from directory, or run
`analysis/helper_scripts/ptables_plan.R`. RMD runs this on a HPC cluster
using `submit_p_pipeline.sbatch`. These are very large files.

# Run plans

Either source one of the pipelines directory or run via sbatch. Running
directly is going to take a lot of CPU.

The plans render dataset-level reports, but these have not been updated
in a while.

# Collect all\_di

Run `analysis/helper_scripts/make_all_di.R` to collect the results from
each of the pipelines into one dataframe.

# Render manuscript-level reports

Running or knitting (an as-yet-uncompiled) doc will reproduce the
figures and results summaries presented in the manuscript.

(rarefaction doc) will reproduce the rarefaction analysis in the
supplement.

(range of variation doc) will reproduce the range of variation analysis
in the supplement.
