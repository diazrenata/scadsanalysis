How to run
================

  - [To explore results](#to-explore-results)
  - [To re-run the analyses](#to-re-run-the-analyses)
      - [Installations](#installations)
      - [Download and prep data](#download-and-prep-data)
      - [Get the p tables](#get-the-p-tables)
      - [Run plans](#run-plans)
      - [Collect results](#collect-results)
      - [Render reports](#render-reports)
          - [all\_di columns](#all_di-columns)

# To explore results

Re-running the whole sampling analysis takes at least a week and
requires a supercomputer. If you would like to just load the results
from the analysis for exploration:

  - Clone or download `diazrenata/scadsanalysis` or the Zenodo archive.
  - Run the snippet in
    `analysis/helper_scripts/load_results_for_exploring.R`.
  - This will give you a dataframe called `all_di`. This is the main
    dataframe for results. It has a lot of columns, descriptions for
    which are [below](#all_di_cols).

If you would like to re-create the figures for the manuscript, you can
re-render the reports in `analysis/reports/submission2`.
`manuscript_main_rev.Rmd` is the figures and tables in the main text,
and the reports in the `appendices` folder render each of the
supplementary documents.

# To re-run the analyses

## Installations

You will need to download and install the package for this research
compendium, as well as packages to run the analytical workflow and
optionally HPC.

``` r
remotes::install_github("diazrenata/scadsanalysis")
install.packages("drake")
install.packages("DBI")
install.packages("storr")
install.packages("clustermq")
```

``` r
library(scadsanalysis)
```

## Download and prep data

To download and prep the main datasets:

``` r
download_data()
```

To subsample the main datasets (subsampling was added after the core
analyses were completed), render `analysis/helper_scripts/jacknife.Rmd`.
You may need to create a directory called
`analysis/rev_prototyping/jacknifed_datasets`.

## Get the p tables

For sampling, you will need tables listing the number of possible SADs
for combinations of S and N. This analysis uses 3 tables covering
different swaths of SxN space. The first two can be created by running
`analysis/helper_scripts/make_p_wide.R` and
`analysis/helper_scripts/make_p_mamm.R`, and the largest one by running
`analysis/helper_scripts/ptables_plan.R` (RMD ran this on a HPC cluster
using `submit_p_pipeline.sbatch`). The files are too large for GitHub,
but will be uploaded to Zenodo and made available for download there.

To run a subset locally, you can just run
`analysis/helper_scripts/make_p_mamm.R` or download `masterp_mamm.Rds`
to the `analysis` directory.

## Run plans

Each dataset is run in its own (identical) pipeline, and we collect the
results at the end. Either source one of the pipelines directly or run
via sbatch. Running one of the pipeline files locally is not
recommended.

To run on the HiperGator, ssh in and run:

`sbatch submit_bbs_pipeline.sbatch`, substituting whatever dataset name
you want to run.

Running on a different HPC cluster would take some setup. On the
HiPerGator, we’re using `drake` and SQLite caches to manage the
pipelines, and `clustermq` to handle parallelization with the SLURM
scheduler.

To run a subset locally, you can run `mcdb_pipeline_demo.R`. This will
run the pipeline on the first 100 communities in the Mammal Community
Database. It takes \[time\] on a MacBook Air with 8GB memory and creates
a \[size\] cache file.

## Collect results

Run `analysis/helper_scripts/make_all_di.R`,
`analysis/helper_scripts/make_all_di_jk.R`,
`analysis/helper_scripts/make_all_ct.R` and
`analysis/helper_scripts/make_all_ct_jk.R` to collect the results from
each of the pipelines into dataframes. If you ran the pipelines on a HPC
cluster, run these scripts and copy the .csvs they create (currently
stored at `analysis/reports/submission2/all_di.csv`, `all_di_jk.csv`,
etc) to your local computer for viewing.

For the local subset, you can run
`analysis/helper_scripts/make_all_di_demo.R`. This will create the
analogous results files for just the subset you ran.

If you want to explore the results (and not re-run the actual analyses)
these files are stored in GitHub/Zenodo at the paths above. You can just
download the archive and work from these .csvs.

## Render reports

RMarkdown files for generating all of the figures and tables in the
manuscript & supplements are at `analysis/reports/submission2`.
`manuscript_main_rev.Rmd` renders the figures in the main text, and the
.Rmd files in `analysis/reports/submission2/appendices` renders each of
the supplementary documents. Once you have run the `make_all_X` scripts,
or downloaded the results files, you can render any of these reports.

To load the results for further exploration, you can start from the code
in `analysis/helper_scripts/load_results_for_exploring.R`. This is the
same setup snippet as begins the .Rmd files.

<a id="all_di_cols"></a>

### all\_di columns

`all_di` will be your main dataframe for exploring. It has a lot of
columns, here is what they mean:

``` r
column_descriptions <- read.csv(here::here("analysis", "reports", "submission2", "all_di_columns.csv" ))

column_descriptions
```

<div class="kable-table">

| column                                 | definition                                                                                                                                                                                                                                                                  | format    |
| :------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-------- |
| sim                                    | Which draw from the sampled feasible set (1-4000), or -99 (for the observed SAD). For the final results dataframes, all values are -99.                                                                                                                                     | Int       |
| source                                 | Whether the SAD is “sampled” or “observed”. For these dataframes, all values are “observed”.                                                                                                                                                                                | Character |
| dat                                    | Which dataset (in terms of the different dataset pipelines). Note that fia\_short and fia\_small are both FIA but have different values here.                                                                                                                               | Character |
| site                                   | Which community (they are called sites in the data files) within each dataset.                                                                                                                                                                                              | Int       |
| singletons                             | Whether the SAD is the raw SAD (FALSE) or the SAD adjusted for undersampling of rare species ( TRUE)                                                                                                                                                                        | Logical   |
| s0                                     | The number of species in the community                                                                                                                                                                                                                                      | Int       |
| n0                                     | The number of individuals in the community                                                                                                                                                                                                                                  | Int       |
| nparts                                 | The number of possible SADs with s0 and n0 (the number of elements in the feasible set)                                                                                                                                                                                     | bigInt    |
| skew                                   | Skewness of the observed SAD                                                                                                                                                                                                                                                | Numeric   |
| shannon                                | Shannon’s index of the observed SAD                                                                                                                                                                                                                                         | Numeric   |
| simpson                                | Simpson’s evenness of the observed SAD                                                                                                                                                                                                                                      | Numeric   |
| nsingletons                            | Number of species with abundance = 1 in the observed SAD                                                                                                                                                                                                                    | Numeric   |
| mean\_po\_comparison                   | NOT USED. The mean dissimilarity of the observed SAD to elements of the FS. Use real\_po instead                                                                                                                                                                            | Numeric   |
| n\_po\_comparisons                     | NOT USED. Number of dissimilarity comparisons achieved between elements of the FS. Use ncomparisons instead.                                                                                                                                                                | Numeric   |
| skew\_percentile                       | Percentile score of observed skewness relative to sampled values. Defined as the % of sampled values LESS THAN OR EQUAL TO observed.                                                                                                                                        | Numeric   |
| shannon\_percentile                    | Percentile score of observed Shannon relative to sampled values. Defined as the % of sampled values LESS THAN OR EQUAL TO observed.                                                                                                                                         | Numeric   |
| simpson\_percentile                    | Percentile score of observed Simpson relative to sampled values. Defined as the % of sampled values LESS THAN OR EQUAL TO observed.                                                                                                                                         | Numeric   |
| skew\_percentile\_excl                 | Percentile score of observed skewness relative to sampled values. Defined as the % of sampled values LESS THAN observed.                                                                                                                                                    | Numeric   |
| simpson\_percentile\_excl              | Percentile score of observed Shannon relative to sampled values. Defined as the % of sampled values LESS THAN observed.                                                                                                                                                     | Numeric   |
| shannon\_percentile\_excl              | Percentile score of observed Simpson relative to sampled values. Defined as the % of sampled values LESS THAN observed.                                                                                                                                                     | Numeric   |
| nsingletons\_percentile                | Percentile score of observed number of species with abundance = 1 relative to sampled values. Defined as the % of sampled values LESS THAN OR EQUAL TO observed.                                                                                                            | Numeric   |
| nsingletons\_percentile\_excl          | Percentile score of observed number of species with abundance = 1 relative to sampled values. Defined as the % of sampled values LESS THAN observed.                                                                                                                        | Numeric   |
| mean\_po\_comparison\_percentile       | NOT USED. Percentile score of dissimilarity of the observed SAD to the feasible set relative to sampled values. Defined as the % of sampled values LESS THAN OR EQUAL TO observed.                                                                                          | Numeric   |
| mean\_po\_comparison\_percentile\_excl | NOT USED. Percentile score of observed dissimilarity of the observed SAD to the feasible set relative to sampled values. Defined as the % of sampled values LESS THAN observed.                                                                                             | Numeric   |
| mean\_po\_comparison\_sims             | NOT USED. The mean dissimilarity of sampled SAD to elements of the FS. Use sim\_pos\_from\_best instead                                                                                                                                                                     | Numeric   |
| skew\_range                            | Range of skewness values in the sampled feasible set                                                                                                                                                                                                                        | Numeric   |
| simpson\_range                         | Range of Simpson values in the sampled feasible set.                                                                                                                                                                                                                        | Numeric   |
| nsamples                               | Number of unique draws from the feasible set achieved. Usually 4000, but smaller for small communities.                                                                                                                                                                     | Numeric   |
| skew\_unique                           | Number of unique skewness values in the sampled feasible set                                                                                                                                                                                                                | Numeric   |
| simpson\_unique                        | Number of unique simpson values in the sampled feasible set                                                                                                                                                                                                                 | Numeric   |
| shannon\_unique                        | Number of unique Shannon values in the sampled feasible set                                                                                                                                                                                                                 | Numeric   |
| skew\_2p5                              | .025 quantile of skewness values in the sampled feasible set                                                                                                                                                                                                                | Numeric   |
| skew\_97p5                             | .975 quantile of skewness values in the sampled feasible set                                                                                                                                                                                                                | Numeric   |
| skew\_95                               | .95 quantile of skewness values in the sampled feasible set                                                                                                                                                                                                                 | Numeric   |
| skew\_min                              | Minimum skewness value in the sampled feasible set                                                                                                                                                                                                                          | Numeric   |
| simpson\_max                           | Maximum Simpson’s value in the sampled feasible set                                                                                                                                                                                                                         | Numeric   |
| shannon\_min                           | Minimum Shannon value in the sampled feasible set                                                                                                                                                                                                                           | Numeric   |
| shannon\_2p5                           | .025 quantile of Shanon values in the sampled feasible set                                                                                                                                                                                                                  | Numeric   |
| shannon\_97p5                          | .975 quantile of Shanon values in the sampled feasible set                                                                                                                                                                                                                  | Numeric   |
| shannon\_max                           | .95 quantile of Shanon values in the sampled feasible set                                                                                                                                                                                                                   | Numeric   |
| shannon\_5                             | .05 quantile of Shanon values in the sampled feasible set                                                                                                                                                                                                                   | Numeric   |
| shannon\_range                         | Range of Shanon values in the sampled feasible set                                                                                                                                                                                                                          | Numeric   |
| simpson\_2p5                           | .025 quantile of Simpson values in the sampled feasible set                                                                                                                                                                                                                 | Numeric   |
| simpson\_5                             | .05 quantile of Simpson values in the sampled feasible set                                                                                                                                                                                                                  | Numeric   |
| simpson\_97p5                          | .975 quantile of Simpson values in the sampled feasible set                                                                                                                                                                                                                 | Numeric   |
| mean\_po\_comparison\_95               | NOT USED. .95 quantile of sampled SADs dissimilarity to other samples in the FS.                                                                                                                                                                                            | Numeric   |
| mean\_po\_comparison\_min              | NOT USED. Min of sampled SADs dissimilarity to other samples in the FS.                                                                                                                                                                                                     | Numeric   |
| mean\_po\_comparison\_max              | NOT USED. Max of sampled SADs dissimilarity to other samples in the FS.                                                                                                                                                                                                     | Numeric   |
| nsingletons\_mean                      | Mean number of species with abund =1 in the sampled feasible set                                                                                                                                                                                                            | Numeric   |
| nsingletons\_95                        | .95 quantile of number of species with abund = 1 in the sampled feasible set                                                                                                                                                                                                | Numeric   |
| nsingletons\_median                    | Median number of species with abund = 1 in the sampled feasible set                                                                                                                                                                                                         | Numeric   |
| nsingletons\_min                       | Minimum number of species with abund = 1 in the sampled feasible set                                                                                                                                                                                                        | Numeric   |
| nsingletons\_max                       | Maximum number of species with abund = 1 in the sampled feasible set                                                                                                                                                                                                        | Numeric   |
| nsingletons\_2p5                       | .025 quantile number of species with abund = 1 in the sampled feasible set                                                                                                                                                                                                  | Numeric   |
| nsingletons\_97p5                      | .975 quantile number of species with abund = 1 in the sampled feasible set                                                                                                                                                                                                  | Numeric   |
| skew\_95\_ratio\_2t                    | 2 tailed breadth index for skewness in the sampled feasible set. (.975 quantile - .025 quantile) / (max - min)                                                                                                                                                              | Numeric   |
| simpson\_95\_ratio\_2t                 | 2 tailed breadth index for simpson in the sampled feasible set. (.975 quantile - .025 quantile) / (max - min)                                                                                                                                                               | Numeric   |
| skew\_95\_ratio\_1t                    | 1 tailed breadth index for skewness in the sampled feasible set. (.95 quantile - min) / (max - min)                                                                                                                                                                         | Numeric   |
| simpson\_95\_ratio\_1t                 | 1 tailed breadth index for simpson in the sampled feasible set. (max - .05 quantile) / (max - min)                                                                                                                                                                          | Numeric   |
| shannon\_95\_ratio\_2t                 | 2 tailed breadth index for Shannon in the sampled feasible set. (.975 quantile - .025 quantile) / (max - min)                                                                                                                                                               | Numeric   |
| shannon\_95\_ratio\_1t                 | 1 tailed breadth index for Shannon in the sampled feasible set. (max - .05 quantile) / (max - min)                                                                                                                                                                          | Numeric   |
| mean\_po\_comparison\_95\_ratio\_1t    | NOT USED. Breadth index for proportion off of elements of the sampled feasible set to each other. (.95 quantile - min) / (max - min)                                                                                                                                        | Numeric   |
| nsingletons\_95\_ratio\_1t             | 1 tailed breadth index for number of species with abund = 1 in the sampled feasible set. (.95 quantile - min) / (max - min)                                                                                                                                                 | Numeric   |
| nsingletons\_95\_ratio\_2t             | 2 tailed breadth index for number of species with abund = 1 in the sampled feasible set. (.975 quantile - .025 quantile) / (max - min)                                                                                                                                      | Numeric   |
| log\_nparts                            | log number of possible SADs with s0 and n0                                                                                                                                                                                                                                  | Numeric   |
| log\_nsamples                          | log number of unique draws achieved from feasible set                                                                                                                                                                                                                       | Numeric   |
| log\_s0                                | log number of species                                                                                                                                                                                                                                                       | Numeric   |
| log\_n0                                | log number of individuals                                                                                                                                                                                                                                                   | Numeric   |
| Dataset                                | Name of dataset, properly capitalized and with fia\_short and fia\_small combined back into FIA                                                                                                                                                                             | Character |
| real\_po                               | Dissimilarity score comparing observed SAD to the central tendency of the feasible set                                                                                                                                                                                      | Numeric   |
| real\_r2                               | R2 comparing observed SAD to the central tendency of the feasible set                                                                                                                                                                                                       | Numeric   |
| best\_po\_sim                          | Which draw from the sampled feasible set is estimated to be the central tendency                                                                                                                                                                                            | Numeric   |
| sim\_pos\_from\_best                   | Mean dissimilarity score comparing samples of the feasible set to its central tendency                                                                                                                                                                                      | Numeric   |
| sim\_r2\_from\_best                    | R2 comparing samples of the feasible set to its central tendency                                                                                                                                                                                                            | Numeric   |
| sim\_r2\_from\_best\_median            | Median r2 comparing samples of the feasible set to its central tendency                                                                                                                                                                                                     | Numeric   |
| ncomparisons                           | Number of comparisons achieved comparing samples of the feasible set to the central tendency. Usually 3999, but may be smaller for smaller feasible sets.                                                                                                                   | Numeric   |
| real\_po\_percentile                   | Percentile score of dissimilarity between observed SAD and the central tendency of the feasible set, compared to dissimilarity scores comparing samples from the feasible set to the central tendency. Defined as % of sampled values LESS THAN OR EQUAL TO observed value. | Numeric   |
| real\_po\_percentile\_excl             | Percentile score of dissimilarity between observed SAD and the central tendency of the feasible set, compared to dissimilarity scores comparing samples from the feasible set to the central tendency. Defined as % of sampled values LESS THAN observed value.             | Numeric   |
| real\_r2\_percentile                   | Percentile score of r2 between observed SAD and the central tendency of the feasible set, compared to r2 scores comparing samples from the feasible set to the central tendency. Defined as % of sampled values LESS THAN OR EQUAL TO observed value.                       | Numeric   |
| real\_r2\_percentile\_excl             | Percentile score of r2 between observed SAD and the central tendency of the feasible set, compared to r2 scores comparing samples from the feasible set to the central tendency. Defined as % of sampled values LESS THAN observed value.                                   | Numeric   |
| real\_po\_percentile\_mean             | Mean of real\_po\_percentile and real\_po\_percentile\_excl. Used for plotting.                                                                                                                                                                                             | Numeric   |
| skew\_percentile\_mean                 | Mean of skew\_percentile and skew\_percentile\_excl. Used for plotting.                                                                                                                                                                                                     | Numeric   |
| simpson\_percentile\_mean              | Mean of simpson\_percentile and simpson\_percentile\_excl. Used for plotting.                                                                                                                                                                                               | Numeric   |
| shannon\_percentile\_mean              | Mean of shannon\_percentile and shannon\_percentile\_excl. Used for plotting.                                                                                                                                                                                               | Numeric   |
| nsingletons\_percentile\_mean          | Mean of nsingletons\_percentile and nsingletons\_percentile\_excl. Used for plotting.                                                                                                                                                                                       | Numeric   |
| in\_fia                                | Whether or not this community is part of the FIA dataset.                                                                                                                                                                                                                   | Logical   |

</div>
