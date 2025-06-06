\name{processReads}
\alias{processReads}
\alias{processReads,AlignedRead-method}
\alias{processReads,RangedData-method}
\title{
Process reads from High-Troughtput Sequencing experiments
}
\description{
This method allows the processment of NGS nucleosome reads from different
sources and a basic manipulation of them. The tasks includes the correction
of strand-specific single-end reads and the trimming of reads to a given length. 
}
\usage{
\S4method{processReads}{AlignedRead}(data, type = "single", fragmentLen, trim, ...)
\S4method{processReads}{RangedData}(data, type = "single", fragmentLen, trim, ...)
}
\arguments{
  \item{data}{
	Sequence reads objects, probably imported using other packages as \code{ShortRead}.	Allowed object types are \code{AlignedRead} and \code{RangedData} with a \code{strand} attribute.
}
  \item{type}{
	Describes the type of reads. Values allowed are \code{single} for single-ended reads and \code{paired} for paired-ended.
}
  \item{fragmentLen}{
	Expected original length of the sequenced fragments. See details.	
}
  \item{trim}{
	Length to trim the reads (or extend them if \code{trim} > read length)
}
	\item{\dots}{
	Other parameters passed to \code{fragmentLenDetect} if no fixed \code{fragmentLen} is given.
}
}
\details{
	This function reads a \code{AlignedRead} or a \code{RangedData} object containing the position, length and strand of the sequence reads.

	It allows the processment of both paired and single ended reads. In the case of single end reads this function corrects the strand-specific mapping by shifting plus strand reads and minus strand reads towards a middle position where both strands are overlaped. This is done by accounting the expected fragment length (\code{fragmentLen}). 

	For paired end reads, mononucleosomal reads could extend more than expected length due to mapping issues or experimental conditions. In this case, the \code{fragmentLen} variable sets the threshold from which reads longer than it should be ignored.

	If no value is supplied for \code{fragmentLen} it will be calculated automatically (increasing the computing time) using \code{fragmentLenDetect} with default parameters. Performance can be increased by tunning \code{fragmentLenDetect} parameteres in a separated call and passing its result as \code{fragmentLen} parameter. 

	In some cases, could be useful trim the reads to a shorter length to improve the detection of nucleosome dyads, easing its detection and automatic positioning. The parameter \code{trim} allows the selection of how many nucleotides select from each read.
	
	A special case for single-ended data is setting the \code{trim} to the same value as \code{fragmentLen}, so the reads will be extended strand-wise towards the 3' direction, creating an artificial map comparable with paired-ended data. The same but opposite can be performed with paired-end data, setting a \code{trim} value equal to the read length from paired ended, so paired-ended data will look like single-ended..
}
\note{
  \strong{IMPORTANT}: this information is only used to correct possible strand-specific mapping, this package doesn't link the two ends of paired reads.
}
\value{
	\code{RangedData} containing the aligned/trimmed individual reads
}
\author{
	Oscar Flores \email{oflores@mmb.pcb.ub.es}
}
\seealso{
	\code{\link[ShortRead]{AlignedRead}}, \code{\link{RangedData}}, \code{\link{fragmentLenDetect}}
}
\keyword{manip}
\examples{
	
	#Load data	
	data(nucleosome_htseq)
	
	#Process nucleosome reads, select only those shorter than 200bp
	pr1 = processReads(nucleosome_htseq, fragmentLen=200)
	
	#Now process them, but picking only the 40 bases surrounding the dyad
	pr2 = processReads(nucleosome_htseq, fragmentLen=200, trim=40)

	#Compare the results:
	par(mfrow=c(2,1), mar=c(3,4,1,1))
	plot(as.vector(coverage(pr1)[["chr1"]]), type="l", ylab="coverage (original)")
	plot(as.vector(coverage(pr2)[["chr1"]]), type="l", ylab="coverage (trimmed)")


}
