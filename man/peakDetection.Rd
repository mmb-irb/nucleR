\name{peakDetection}
\alias{peakDetection}
\alias{peakDetection,list-method}
\alias{peakDetection,numeric-method}
\title{
	Detect peaks (local maximum) from values series
}
\description{
	This function allows a efficient recognition of the local maximums (peaks) in a given numeric vector.
	
	It's recommended to smooth the input with \code{filterFFT} prior the detection.	
}
\usage{
\S4method{peakDetection}{list}(data, threshold="25\%", width=1, score=TRUE, mc.cores=1)
\S4method{peakDetection}{numeric}(data, threshold="25\%", width=1, score=TRUE, mc.cores=1)
}
\arguments{
  \item{data}{
	Input numeric values, or a list of them
}
	\item{threshold}{
	Threshold value from which the peaks will be selected. Can be given as a percentage string (i.e., \code{"25\%"} will use the value in the 1st quantile of \code{data}) or as an absolute coverage numeric value (i.e., \code{20} will not look for peaks in regions without less than 20 reads (or reads per milion)).
}
	\item{width}{
	If a positive integer > 1 is given, the peaks are returned as a range of the given width centered in the local maximum. Useful for nucleosome calling from a coverage peak in the dyad.
}
	\item{score}{	
	If TRUE, the results will be scored using \code{peakScoring} function
}
  \item{mc.cores}{
	If \code{multicore} support, the number of cores available
}
}
\value{
	The type of the return depends on the input parameters:

	\code{numeric} (or a list of them) if \code{width==1 & score==FALSE} containing the position of the peaks

	\code{data.frame} (or list of them) if \code{width==1 & score==TRUE} containing a 'peak' column with the position of the peak plus a 'score' column with its score.

	\code{IRanges} (or \code{IRangesList}) if \code{width>1 & score==FALSE} containing the ranges of the peaks.

	\code{RangedData} if \code{width>1 & score==TRUE} containing the ranges of the peaks and the assigned score.
}
\note{
	If \code{width} > 1, those ranges outside the range \code{1:length(data)} will be skipped
}
\author{
	Oscar Flores \email{oflores@mmb.pcb.ub.es}
}
\seealso{
	\code{\link{filterFFT}}, \code{\link{peakScoring}}
}
\keyword{ manip }
\examples{
	
	#Generate a random peaks profile
	reads = syntheticNucMap(nuc.len=40, lin.len=130)$syn.reads
	cover = coverage(reads)
	
	#Filter them
	cover_fft = filterFFT(cover)
	
	#Detect and plot peaks (up a bit the threshold for accounting synthetic data)
	peaks = peakDetection(cover_fft, threshold="40\%", score=TRUE)
	plotPeaks(peaks, cover_fft, threshold="40\%", start=10000, end=15000)

	#Now use ranges version, which accounts for fuzziness when scoring
  peaks = peakDetection(cover_fft, threshold="40\%", score=TRUE, width=147)
  plotPeaks(peaks, cover_fft, threshold="40\%", start=10000, end=15000)
}
