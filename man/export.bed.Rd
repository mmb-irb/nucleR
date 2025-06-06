\name{export.bed}
\alias{export.bed}
\alias{.export.bed}
\alias{export.bed,IRanges-method}
\alias{export.bed,CompressedIRangesList-method}
\alias{export.bed,RangedData-method}
\alias{export.bed,GRanges-method}
\title{
    Export ranges in BED format
}
\description{
    Export ranges in BED format, compatible with UCSC genome browser, IGB, and
    others
}
\usage{
    \S4method{export.bed}{IRanges}(ranges, score=NULL, chrom, name, desc=name, filepath=name)
    \S4method{export.bed}{CompressedIRangesList}(ranges, score=NULL, name, desc=name, filepath=name, splitByChrom=TRUE)
    \S4method{export.bed}{RangedData}(ranges, score=NULL, name, desc=name, filepath=name, splitByChrom=TRUE)
    \S4method{export.bed}{GRanges}(ranges, score=NULL, name, desc=name, filepath=name, splitByChrom=TRUE)
}
\arguments{
    \item{ranges}{
        Ranges to export, in \code{IRanges}, \code{IRangesList} or
        \code{RangedData} format
    }
    \item{score}{
        Score data if not included in \code{ranges} object. Bed file will put
        all scores=1000 if scores are not present
    }
    \item{chrom}{
        For single \code{IRanges} objects, the chromosome they represent. For
        other data types, values from \code{names(...)} will be used.
    }
    \item{name}{
        Name of the track
    }
    \item{desc}{
        Description of the track
    }
    \item{filepath}{
        Path and prefix of the file(s) to write. Chromosome number and "bed"
        extension will be automatically added.
    }
    \item{splitByChrom}{
        If multiple chromosomes are given, should they be splitted into one
        file per chromosome or shall them be saved all together?
    }
}
\value{
    (none)
}
\references{
    BED format specification: http://genome.ucsc.edu/FAQ/FAQformat#format1
}
\author{
    Oscar Flores \email{oflores@mmb.pcb.ub.es}
}
\keyword{ file }
\examples{
    \dontrun{
        # Generate random ranges with scores
        ran <- RangedData(IRanges(start=1:100, end=101:200), score=(1:100) / 100)
        names(ran) <- "chrX"

        # Export as bed file
        export.bed(ran, name="test_track", description="Just a test track")

        # If executed, this would create a file named "test_track.chrX.bed" with:

        #    track name="test_track" description="Just a test track" useScore=0
        # chrX    1 101 nucl1 0.01
        # chrX    2 102 nucl2 0.02
        # chrX    3 103 nucl3 0.03
        # ...
    }
}
