% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/seq_sensitivity.R
\name{break.me}
\alias{break.me}
\title{Break Me}
\usage{
break.me(metrics.df, breaks = 100, site.info.thresh = 6)
}
\arguments{
\item{metrics.df}{= data frame of metric values for each station with site
a column of site classes defined by environmental variables.}

\item{breaks}{= intervals at which columns will be subdivided.}

\item{site.info.thesh}{= the last column indicating site information. The next
column should represent metric values.}
}
\value{
Subdivides a large data frame into multiple data frames that are
contained within a list.  Breaking a large data frame into multiple smaller
data frames will hopefully reduce the memory requirements.
}
\description{
Break Me
}
