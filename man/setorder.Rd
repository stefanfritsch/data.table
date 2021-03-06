\name{setorder}
\alias{setorder}
\alias{setorderv}
\alias{setcolorder}
\alias{order}
\alias{fastorder}
\alias{forder}

\title{Fast reordering of a data.table by reference}
\description{
  In \code{data.table} parlance, all \code{set*} functions change their input \emph{by reference}. That is, no copy is made at all, other than temporary working memory, which is as large as one column.. The only other \code{data.table} operator that modifies input by reference is \code{\link{:=}}. Check out the \code{See Also} section below for other \code{set*} function \code{data.table} provides.

  \code{setcolorder} reorders the columns of data.table, \emph{by reference}, to the new order provided.
  
  \code{setorder} (and \code{setorderv}) reorders the rows of a \code{data.table} \emph{by reference}, based on the columns provided. It can sort in both ascending and descending order. The functionality is identical to using \code{?order} on a \code{data.frame}, except much faster, very memory efficient and much more user-friendly.
  
  \code{x[order(.)]} is now optimised internally to use \code{data.table}'s fast order by default. \code{data.table} by default always sorts in C-locale. If instead, it is essential to sort by the session locale, one could always revert back to base's \code{order} by doing: \code{x[base:::order(.)]}.
  
  \code{bit64:::integer64} type is also supported for reordering rows of a \code{data.table}.
}

\usage{
setcolorder(x, neworder)
setorder(x, ..., na.last=FALSE)
setorderv(x, cols, order=1L, na.last=FALSE)
# optimised to use data.table's internal fast order
# x[order(., na.last=TRUE)]
}
\arguments{
  \item{x}{ A \code{data.table}. }
  \item{neworder}{ Character vector of the new column name ordering. May also be column numbers. }
  \item{...}{ The columns to sort by. Do not quote column names. If \code{...} is missing (ex: \code{setorder(x)}), \code{x} is rearranged based on all columns in ascending order by default. To sort by a column in descending order prefix a \code{"-"}, i.e., \code{setorder(x, a, -b, c)}. The \code{-b} works when \code{b} is of type \code{character} as well. }
  \item{cols}{ A character vector of column names of \code{x}, to which to order by. Do not add \code{"-"} here.}
  \item{order}{ An integer vector with only possible values of \code{1} and \code{-1}, corresponding to ascending and descending order. The length of \code{order} must be either \code{1} or equal to that of \code{cols}. If \code{length(order) == 1}, it's recycled to \code{length(cols)}. }
  \item{na.last}{logical. If \code{TRUE}, missing values in the data are placed last; if \code{FALSE}, they are placed first; if \code{NA} they are removed. \code{na.last=NA} is valid only for \code{x[order(., na.last)]} and it's default is \code{TRUE}. \code{setorder} and \code{setorderv} only accept TRUE/FALSE with default \code{FALSE}.}
}
\details{
  When it's required to reorder the columns of a \code{data.table}, the idiomatic way is to use \code{setcolorder(x, neworder)}, instead of doing \code{x <- x[, neworder, with=FALSE]}. This is because the latter makes an entire copy of the \code{data.table}, which maybe unnecessary in most situations. \code{setcolorder} also allows column numbers instead of column names for \code{neworder} argument, although it isn't good programming practice to use column numbers. We recommend using column names.
  
  \code{data.table} internally implements extremely fast radix based ordering. However, in versions <= 1.9.2, fast ordering was only capable of increasing order (ascending). In versions >1.9.2, the functionality has been extended to decreasing order (descending) as well. Note that \code{\link{setkey}} still requires and will only sort in ascending order, and is not related to \code{setorder}. 
  
  By implementing \code{forder} to handle decreasing order as well, we now don't have to rely on \code{base:::order} anymore. It is now possible to reorder the rows of a \code{data.table} based on columns by reference, ex: \code{setorder(x, a, -b, c)}. Note that, \code{-b} also works with columns of type \code{character}, unlike \code{base:::order} which requires \code{-xtfrm(y)} (and is slow) instead.
  
  \code{na.last} argument, by default, is \code{FALSE} for \code{setorder} and \code{setorderv} to be consistent with \code{data.table}'s \code{setkey} and is \code{TRUE} for \code{x[order(.)]} to be consistent with \code{base:::order}. Only \code{x[order(.)]} can have \code{na.last = NA} as it's a subset operation as opposed to \code{setorder} or \code{setorderv} which reorders the data.table by reference.
  
  Note that if \code{setorder} results in reordering of the rows of a keyed \code{data.table}, then it's key will be set to \code{NULL}.
  }
\value{
    For all \code{set*} functions, the input is modified by reference, and returned (invisibly) so it can be used in compound statements; e.g., \code{setorder(DT,a,-b)[, cumsum(c), by=list(a,b)]}. If you require a copy, take a copy first (using \code{DT2 = copy(DT)}). See \code{?copy}.
}
\seealso{ \code{\link{setkey}}, \code{\link{setattr}}, \code{\link{setnames}}, \code{\link{setencoding}}, \code{\link{set}}, \code{\link{:=}}, \code{\link{setDT}}, \code{\link{setDF}}, \code{\link{copy}}
\if{html}{\out{<script type="text/javascript">var sc_project=6237851;var sc_invisible=1;var sc_security="518c93ca";</script><script type="text/javascript" src="http://www.statcounter.com/counter/counter.js"></script><noscript><div class="statcounter"><a title="web statistics" href="http://statcounter.com/free-web-stats/" target="_blank"><img class="statcounter" src="http://c.statcounter.com/6237851/0/518c93ca/1/" alt="web statistics"></a></div></noscript>}}
}
\examples{

set.seed(45L)
DT = data.table(A=sample(3, 10, TRUE), 
         B=sample(letters[1:3], 10, TRUE), C=sample(10))

# setorder
setorder(DT, A, -B)
# same as above but using 'setorderv'
# setorderv(DT, c("A", "B"), c(1,-1))

# setcolorder
setcolorder(DT, c("C", "A", "B"))
}
\keyword{ data }

