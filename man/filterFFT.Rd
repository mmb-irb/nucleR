\name{filterFFT}
\alias{filterFFT}
\alias{filterFFT,SimpleRleList-method}
\alias{filterFFT,Rle-method}
\alias{filterFFT,list-method}
\alias{filterFFT,numeric-method}
\title{
	Clean noise and smoothing for genomic data using Fourier-analysis
}
\description{
	Remove noise from genomic data smoothing and cleaning the observed signal. This function
	doesn't alter the shape or the values of the signal as much as the traditional method of
	sliding window average does, providing a great correlation within the original and filtered
	data (>0.99).
}
\usage{
\S4method{filterFFT}{SimpleRleList}(data, pcKeepComp="auto", showPowerSpec=FALSE, useOptim=TRUE, mc.cores=1, ...)
\S4method{filterFFT}{list}(data, pcKeepComp="auto", showPowerSpec=FALSE, useOptim=TRUE, mc.cores=1, ...)
\S4method{filterFFT}{Rle}(data, pcKeepComp="auto", showPowerSpec=FALSE, useOptim=TRUE, ...)
\S4method{filterFFT}{numeric}(data, pcKeepComp="auto", showPowerSpec=FALSE, useOptim=TRUE, ...)
}
\arguments{
  \item{data}{
	Coverage or intensities values representing the results of the NGS of TA experiment. This attribute could be a individual vector representing a chromosome (\code{Rle} or \code{numeric} object) or a list of them.
}
	\item{pcKeepComp}{
	Number of components to select, in percentage respect total length of the sample. Allowed values are numeric (in range 0:1) for manual setting or "auto" for automatic detection. See details.
}
  \item{showPowerSpec}{
	Plot the Power Spectrum of the Fast Fourier Transform to visually identify the selected components (see details).
}
	\item{useOptim}{
	This function implements tweaks to a standard fft call to improve (dramatically) the performance in large genomic data. These optimizations can be bypassed by setting this parameter to \code{FALSE}.
}
	\item{mc.cores}{
	If multiple cores are available, maximum number of them to use for parallel processing of \code{data} elements (only useful if \code{data} is a list of elements)
	}
	\item{\dots}{
	Other parameters to be passed to \code{pcKeepCompDetect} function
}
}
\details{
	Fourier-analysis principal components selection is widely used in signal processing theory for an unbiased cleaning of a signal over the time.

	Other procedures, as the traditional sliding window average, can change too much the shape of the results in function of the size of the window, and moreover they don't only smooth the noise without removing it.

	With a Fourier Transform of the original signal, the input signal is descomposed in diferent wavelets and described as a combination of them. Long frequencies can be explained as a function of two ore more periodical shorter frequecies. This is the reason why long, unperiodic sequences are usually identified as noise, and therefore is desireable to remove them from the signal we have to process. 

 	This procedure here is applied to genomic data, providing a novel method to obtain perfectly clean values wich allow an efficient detection of the peaks which can be used for a direct nucleosome position recognition.

	This function select a certain number of components in the original power spectrum (the result of the Fast Fourier Transform which can be seen with \code{showPowerSpec=TRUE}) and sets the rest of them to 0 (component knock-out).

	The amout of components to keep (given as a percentage of the input lenght) can be set by the \code{pcKeepComp}. This will select the first components of the signal, knock-outing the rest. If this value is close to 1, more components will be selected and then more noise will be allowed in the output. For an effective filtering which removes the noise keeping almost all relevant peaks, a value between 0.01 and 0.05 is usually sufficient. Lower values can cause merging of adjacent minor peaks.

	This library also allows the automatic detection of a fitted value for \code{pcKeepComp}. By default, if uses the \code{pcKeepCompDetect} function, which looks which is the minimum percentage of components than can reproduce the original signal with a corelation between the filtered and the original one of 0.99. See the help page of \code{pcKeepCompDetect} for further details and reference of available parameters.

	One of the most powerful features of \code{nucleR} is the efficient implementation of the FFT to genomic data. This is achived trought few tweaks that allow an optimum performance of the Fourier Transform. This includes a by-range filtering, an automatic detection of uncovered regions, windowed execution of the filter and padding of the data till nearest power of 2 (this ensures an optimum case for FFT due the high factorization of components). Internal testing showed up that in specific datasets, these optimizations lead to a dramatic improvement of many orders of magnitude (from 3 days to few seconds) while keeping the correlation between the native \code{fft} call and our \code{filterFFT} higher than 0.99. So, the use of these optimizations is highly recomended.

	If for some reason you want to apply the function without any kind of optimizations you can specify the parameter \code{useOptim=FALSE} to bypass them and get the pure knockout inverse from native FFT call. All other parameters can be still applyied in this case.
}
\value{
	Numeric vector with cleaned/smoothed values
}
\references{
	Smith, Steven W. (1999), The Scientist and Engineer's Guide to Digital Signal Processing (Second ed.), San Diego, Calif.: California Technical Publishing, ISBN 0-9660176-3-3 (availabe online: http://www.dspguide.com/pdfbook.htm)
}
\author{
	Oscar Flores \email{oflores@mmb.pcb.ub.es}, David Rosell \email{david.rossell@irbbarcelona.org}
}
\keyword{ manip }
\examples{
	#Load example data, raw hybridization values for Tiling Array
	raw_data = get(data(nucleosome_tiling))
	
	#Filter data
	fft_data = filterFFT(raw_data, pcKeepComp=0.01)

	#See both profiles
	par(mfrow=c(2,1), mar=c(3, 4, 1, 1))
	plot(raw_data, type="l", xlab="position", ylab="Raw intensities")
	plot(fft_data, type="l", xlab="position", ylab="Filtered intensities")

	#The power spectrum shows a visual representation of the components
	fft_data = filterFFT(raw_data, pcKeepComp=0.01, showPowerSpec=TRUE)
}
