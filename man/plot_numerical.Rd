% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/visualize.R
\name{plot_numerical}
\alias{plot_numerical}
\title{Plot numerical data over regions or regions summarized over annotations}
\usage{
plot_numerical(
  annotated_regions,
  x,
  y,
  facet,
  facet_order,
  bin_width = 10,
  plot_title,
  x_label,
  y_label,
  legend_facet_label,
  legend_cum_label,
  quiet = FALSE
)
}
\arguments{
\item{annotated_regions}{A \code{GRanges} returned from \code{annotate_regions()}. If the data is not summarized, the data is at the region level. If it is summarized, it represents the average or standard deviation of the regions by the character vector used for \code{by} in \code{summarize_numerical()}.}

\item{x}{A string indicating the column of the \code{GRanges} to use for the x-axis.}

\item{y}{A string indicating the column of the \code{GRanges} to use for the y-axis. If missing, a a histogram over \code{x} will be plotted. If not missing, a scatterplot is plotted.}

\item{facet}{A string, or character vector of two strings, indicating indicating which categorical variable(s) in the \code{GRanges} to make \code{ggplot2} facets over. When two facets are given, the first entry is the vertical facet and the second entry is the horizontal facet. Default is \code{annot.type}.}

\item{facet_order}{A character vector, or list of character vectors if \code{facet} has length 2, which gives the order of the facets, and can be used to subset the column in the \code{GRanges} used for the \code{facet}. For example, if \code{facet = 'annot.type'}, then the annotations maybe subsetted to just CpG annotations. Default is \code{NULL}, meaning all annotations in their default order are used.}

\item{bin_width}{An integer indicating the bin width of the histogram used for score. Default 10. Select something appropriate for the data. NOTE: This is only used if \code{y} is \code{NULL}.}

\item{plot_title}{A string used for the title of the plot. If missing, no title is displayed.}

\item{x_label}{A string used for the x-axis label. If missing, no x-axis label is displayed.}

\item{y_label}{A string used for the y-axis label. If missing, no y-axis label is displayed.}

\item{legend_facet_label}{A string used to label the gray bar portion of the legend. Defaults to "x in facet".}

\item{legend_cum_label}{A string used to label the red outline portion of the legend. Defaults to "All in x".}

\item{quiet}{Print progress messages (FALSE) or not (TRUE).}
}
\value{
A \code{ggplot} object which can be viewed by calling it, or saved with \code{ggplot2::ggsave}.
}
\description{
This function produces either histograms over \code{facet}, or x-y scatterplots over \code{facet}. In the case of histograms over facets, the All distribution (hollow histogram with red outline) is the distribution of \code{x} over all the regions in the data. The facet specific distributions (solid gray) are the distribution of \code{x} over the regions in each facet. For example, a CpG with associated percent methylation annotated to a CpG island and a promoter will count once in the All distribution, but will count once each in the CpG island and promoter facet distributions.
}
\examples{
   # An example with multi-columned data

   # Get premade CpG annotations
   data('annotations', package = 'annotatr')

   dm_file = system.file('extdata', 'IDH2mut_v_NBM_multi_data_chr9.txt.gz', package = 'annotatr')
   extraCols = c(diff_meth = 'numeric', mu1 = 'numeric', mu0 = 'numeric')
   dm_regions = read_regions(con = dm_file, extraCols = extraCols,
       rename_score = 'pval', rename_name = 'DM_status', format = 'bed')
   dm_regions = dm_regions[1:1000]

   # Annotate the regions
   dm_annots = annotate_regions(
       regions = dm_regions,
       annotations = annotations,
       ignore.strand = TRUE)

   # Plot histogram of group 1 methylation rates across the CpG annotations.
   # NOTE: Overall distribution (everything in \code{facet_order})
   # is plotted in each facet for comparison.
   dm_vs_regions_mu1 = plot_numerical(
       annotated_regions = dm_annots,
       x = 'mu1',
       facet = 'annot.type',
       facet_order = c('hg19_cpg_islands','hg19_cpg_shores',
           'hg19_cpg_shelves','hg19_cpg_inter'),
       bin_width = 5,
       plot_title = 'Group 1 Methylation over CpG Annotations',
       x_label = 'Group 1 Methylation')

   # Plot histogram of group 1 methylation rates across the CpG annotations
   # crossed with DM_status
   dm_vs_regions_diffmeth = plot_numerical(
       annotated_regions = dm_annots,
       x = 'diff_meth',
       facet = c('annot.type','DM_status'),
       facet_order = list(
           c('hg19_genes_promoters','hg19_genes_5UTRs','hg19_cpg_islands'),
           c('hyper','hypo','none')),
       bin_width = 5,
       plot_title = 'Group 0 Region Methylation In Genes',
       x_label = 'Methylation Difference')

   # Can also use the result of annotate_regions() to plot two numerical
   # data columns against each other for each region, and facet by annotations.
   dm_vs_regions_annot = plot_numerical(
       annotated_regions = dm_annots,
       x = 'mu0',
       y = 'mu1',
       facet = 'annot.type',
       facet_order = c('hg19_cpg_islands','hg19_cpg_shores',
           'hg19_cpg_shelves','hg19_cpg_inter'),
       plot_title = 'Region Methylation: Group 0 vs Group 1',
       x_label = 'Group 0',
       y_label = 'Group 1')

   # Another example, but using differential methylation status as the facets.
   dm_vs_regions_name = plot_numerical(
       annotated_regions = dm_annots,
       x = 'mu0',
       y = 'mu1',
       facet = 'DM_status',
       facet_order = c('hyper','hypo','none'),
       plot_title = 'Region Methylation: Group 0 vs Group 1',
       x_label = 'Group 0',
       y_label = 'Group 1')

}
