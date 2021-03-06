#==============================================================================
# Composition Metrics
#==============================================================================
#'Percentage of a Specified Taxon
#'@description Calculate the percentage of each sample represented by the
#'specified taxon or taxa.
#'@param long.df Taxonomic counts arranged in a long data format.
#'@param unique.id.col The name of the column that contains a unique sampling
#'event ID.
#'@param count.col The name of the column that contains taxanomic counts.
#'@param high.res.taxa.col The name of the column that contains the taxon or taxa
#'of interest.
#'@param taxon The taxon or taxa of interest. To specify more than one taxa
#'use: c("TAXA1", "TAXA2", "TAXA3").
#'@return A numeric vector of percentages.
#'@export


taxa_pct_rich <- function(long.df, unique.id.col, count.col,
                          taxon.col, taxon = NULL,
                          high.res.taxa.col,
                          exclusion.col = NULL, exclusion.vec = NULL) {
  unique.id.col <- rlang::enquo(unique.id.col)
  taxon.col <- rlang::enquo(taxon.col)
  count.col <- rlang::enquo(count.col)
  high.res.taxa.col <- rlang::enquo(high.res.taxa.col)
  exclusion.col <- rlang::enquo(exclusion.col)
  #----------------------------------------------------------------------------
  long.df <- long.df %>%
    dplyr::filter((!!count.col) > 0)
  #----------------------------------------------------------------------------
  if (is.null(taxon)) stop("Must specify 'taxon'.")
  if (!rlang::quo_is_null(exclusion.col) && is.null(exclusion.vec)) {
    stop("Specifying an exclusion.col also requires that you specify the
         objects you want to exclude (i.e. exclusion.vec) from that column.")
  }
  if (!is.null(exclusion.vec) && rlang::quo_is_null(exclusion.col)) {
    stop("Specifying an exclusion.vec also requires that you specify the
         column (i.e. exclusion.col) from which to exclude the objects.")
  }
  #----------------------------------------------------------------------------
  if (rlang::quo_is_null(exclusion.col)) {
    # Aggregate taxonomic counts at the specified taxonomic levels.
    taxa.counts <- long.df %>%
      dplyr::select(!!unique.id.col, !!taxon.col,
                    !!count.col, !!high.res.taxa.col) %>%
      dplyr::distinct()
  } else {
    taxa.counts <- long.df %>%
      dplyr::select(!!unique.id.col, !!taxon.col, !!count.col,
                    !!high.res.taxa.col, !!exclusion.col) %>%
      dplyr::distinct()
  }
  #----------------------------------------------------------------------------
  distinct.df <- taxa.counts %>%
    dplyr::select(!!unique.id.col) %>%
    dplyr::distinct()

  final.vec <- distinct.df %>%
    dplyr::mutate(rich = taxa_rich(taxa.counts,
                                   !!unique.id.col,
                                   !!count.col,
                                   !!high.res.taxa.col),
                  taxa_rich = taxa_rich(taxa.counts,
                                        !!unique.id.col,
                                        !!count.col,
                                        !!taxon.col,
                                        taxon,
                                        !!high.res.taxa.col,
                                        exclusion.col = !!exclusion.col,
                                        exclusion.vec = exclusion.vec),
                  pct_rich = dplyr::if_else(taxa_rich == 0, 0,
                                            taxa_rich / rich * 100)) %>%
    original_order(long.df, !!unique.id.col) %>%
    dplyr::pull(pct_rich)
  #----------------------------------------------------------------------------
  return(final.vec)
  }
