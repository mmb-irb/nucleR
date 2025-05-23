\name{export.wig}
\alias{export.wig}
\title{
	Export values in WIG format
}
\description{
	Export coverage/intensity values in WIG format, compatible with UCSC genome browser, IGB, and others
}
\usage{
export.wig(data, name, chrom="", filepath=name)
}
\arguments{
  \item{data}{
	Coverage/intensity values (numeric 
}
  \item{name}{
	Name of the track
}
  \item{chrom}{
	Information about chromosome if not inferrable from \code{data} (only for numeric vectors) 
}
	\item{filepath}{
	Filepath where to save the object. Chromosome name and "wig" extension will be automatically added
}
}
\value{
	(none)
}
\references{
	WIG format specification: http://genome.ucsc.edu/FAQ/FAQformat#format6
}
\author{
  Oscar Flores \email{oflores@mmb.pcb.ub.es}
}
\keyword{ file }
\examples{
	\dontrun{
		#Load data
		data(nucleosome_htseq)
		cover = coverage.rpm(nucleosome_htseq)
		

		#Create wig file
		export.wig(cover, name="example_track")
		
		#This would create the file "example_track.chr1.wig" with:
	
		#track type=wiggle_0 name="example_track"
		#fixedStep chrom=chr1 start=1 step=1
		#55.55247
		#55.55247
		#55.55247
		#277.7623
		#388.8673
		#...
	}
}
