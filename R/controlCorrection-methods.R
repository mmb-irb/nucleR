#############
setMethod(
    "controlCorrection",
    signature(exp="SimpleRleList"),
    function (exp, ctr, mc.cores=1) {

        if (class(exp) != class(ctr)) {
            stop("'exp' and 'ctr' classes must be equal")
        }

        if (length(which(!(names(exp) %in% names(ctr)))) != 0 |
            length(which(!(names(ctr) %in% names(exp)))) != 0) {
            stop("names should be equal in both datasets")
        }

        res <- .xlapply(
            names(exp),
            function(chr)
                controlCorrection(exp[[chr]], ctr[[chr]]),
            mc.cores=mc.cores
        )
        names(res) <- names(exp)
        return(RleList(res, compress=FALSE))
    }
)

################
setMethod(
    "controlCorrection",
    signature(exp="Rle"),
    function (exp, ctr) {
        if (class(exp) != class(ctr)) {
            stop("'exp' and 'ctr' classes must be equal")
        }
        return(Rle(controlCorrection(as.vector(exp), as.vector(ctr))))
    }
)

################
setMethod(
    "controlCorrection",
    signature(exp="list"),
    function (exp, ctr, mc.cores=1) {

        if (class(exp) != class(ctr)) {
            stop("'exp' and 'ctr' classes must be equal")
        }

        if (length(which(!(names(exp) %in% names(ctr)))) != 0 |
            length(which(!(names(ctr) %in% names(exp)))) != 0) {
            stop("names should be equal in both datasets")
        }

        res <- .xlapply(
            names(exp),
            function(chr)
                controlCorrection(exp[[chr]], ctr[[chr]]),
            mc.cores=mc.cores,
        )
        names(res) <- names(exp)
        return(res)
    }
)

################
setMethod(
    "controlCorrection",
    signature(exp="numeric"),
    function (exp, ctr)  {

        if (class(exp) != class(ctr)) {
            stop("'exp' and 'ctr' classes must be equal")
        }

        res <- exp - (ctr - mean(ctr[ctr != 0]))
        res[res  < 0] <- 0
        return(res)
    }
)
