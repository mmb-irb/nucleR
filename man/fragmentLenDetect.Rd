\name{fragmentLenDetect}
\alias{fragmentLenDetect}
\alias{fragmentLenDetect,AlignedRead-method}
\alias{fragmentLenDetect,RangedData-method}
\title{
	Fragments length detection from single-end sequencing samples
}
\description{
	When using single-ended sequencing, the resulting partial sequences map only in one strand, causing a bias in the coverage profile if not corrected. The only way to correct this is knowing the average size of the real fragments. \code{nucleR} uses this information when preprocessing single-ended sequences. You can provide this information by your own (usually a 147bp length is a good aproximation) or you can use this method to automatically guess the size of the inserts. 
}
\usage{
\S4method{fragmentLenDetect}{AlignedRead}(reads, samples=1000, window=1000, min.shift=1, max.shift=100, mc.cores=1, as.shift=FALSE)
\S4method{fragmentLenDetect}{RangedData}(reads, samples=1000, window=1000, min.shift=1, max.shift=100, mc.cores=1, as.shift=FALSE)
}
\arguments{
  \item{reads}{
	Raw single-end reads (\code{AlignedRead} or \code{RangedData} format)
}
  \item{samples}{
	Number of samples to perform the analysis (more = slower but more accurate)
}
  \item{window}{
	Analysis window. Usually there's no need to touch this parameter.
}
	\item{min.shift, max.shift}{
	Minimum and maximum shift to apply on the strands to detect the optimal fragment size. If the range is too big, the performance decreases.
}
	\item{as.shift}{
	If TRUE, returns the shift needed to align the middle of the reads in opposite strand. If FALSE, returns the mean inferred fragment length.
}
  \item{mc.cores}{
	If multicore support, maximum number of cores allowed to use.
}
}
\details{
	This function shifts one strand downstream one base by one from \code{min.shift} to \code{max.shift}. In every step, the correlation on a random position of length \code{window} is checked between both strands. The maximum correlation is returned and averaged for \code{samples} repetitions.

	The final returned length is the best shift detected plus the width of the reads. You can increase the performance of this function by reducing the \code{samples} value and/or narrowing the shift range. The \code{window} size has almost no impact on the performance, despite a to small value can give biased results.
}
\value{
	Inferred mean lenght of the inserts by default, or shift needed to align strands if \code{as.shift=TRUE}
}
\author{
  Oscar Flores \email{oflores@mmb.pcb.ub.es}
}
\keyword{ attribute }
\examples{

	#Create a sinthetic dataset, simulating single-end reads, for positive and negative strands
	pos = syntheticNucMap(nuc.len=40, lin.len=130)$syn.reads #Positive strand reads
	neg = IRanges(end=start(pos)+147, width=40) #Negative strand (shifted 147bp)
	sim = RangedData(c(pos, neg), strand=c(rep("+", length(pos)), rep("-", length(neg))))

	#Detect fragment lenght (we know by construction it is really 147)
	fragmentLenDetect(sim, samples=50)

	#The function restrict the sampling to speed up the example
}
