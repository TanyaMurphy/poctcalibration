#' ---
#' title: "Achira-McGill R tutorial functions"
#' author: ""
#' date: ""
#' output: 
#'   html_document:
#'     toc: true
#' ---

#' <!-- Sidebar -->
#' <div class="sidebar sidenav affix">
#' <p class="sidebar-brand"><strong>Contents</strong></p>
#' <li>
#' <a href="#curve-functions">Curve functions</a>
#' </li>
#' <li>
#' <a href="#inv-curve-functions">Inverse curve functions</a>
#' </li>
#' <li>
#' <a href="#diagnostic-plots">Diagnostic plots</a>
#' </li>
#' <ul>
#' <li>
#' <a href="#plotdiag-nls">plotDiag.nls</a>
#' </li>
#' <li>
#' <a href="#plotdiag-irls">plotDiag.irls</a>
#' </li>
#' </ul>
#' <li>
#' <a href="#irls-nls">IRLS.nls functions</a>
#' </li>
#' <ul>
#' <li>
#' <a href="#irls4pl">IRLS.4pl</a>
#' </li>
#' <li>
#' <a href="#summaryirls">summaryIRLS</a>
#' </li>
#' </ul>
#' <li>
#' <a href="#inv-pred">Inverse prediction functions</a>
#' </li>
#' <ul>
#' <li>
#' <a href="#sdXhat">sdXhat</a>
#' </li>
#' <li>
#' <a href="#predictconc-4pl">predictConc.4pl</a>
#' </li>
#' </ul>
#' </div>
#'         
#' <h1 id="curve-functions">Curve functions</h1>

# -------------- Define models -----------------------------------
# Michaelis-Menten model
M.micmen <- function(x, offset, Vm, K){
    f <- offset + Vm * x / (K + x)
    return(f)
}

# 4PL model
M.4pl <- function(x, small.x.asymp, inf.x.asymp, inflec, hill){
    f <- small.x.asymp + ((inf.x.asymp - small.x.asymp)/
                              (1 + (x / inflec)^hill))
    return(f)
}

# 5PL model  
M.5pl <- function(x, small.x.asymp, inf.x.asymp, c.5pl, hill, g.5pl){
    f <- small.x.asymp + ((inf.x.asymp - small.x.asymp)/
                              (1 + (x / c.5pl)^hill)^g.5pl)
    return(f)
}

#' <h1 id="inv-curve-functions">Inverse curve functions</h1>
# ----- Inverse functions -------------------------
Inv.lr <- function(y, int, beta){
    f <- (y - int)/ beta
    names(f) <- "x.hat"
    return(f)
} 

Inv.micmen <- function(y, offset, Vm, K){
    f <- K * (y - offset) / (Vm - (y - offset))
    names(f) <- "x.hat"
    return(f)
} 

Inv.4pl <- function(y, small.x.asymp, inf.x.asymp, inflec, hill){
    f <- inflec * ((inf.x.asymp - small.x.asymp) / 
                       (y - small.x.asymp) - 1)^(1 / hill)
    names(f) <- "x.hat"
    return(f)
} 

Inv.5pl <- function(y, small.x.asymp, inf.x.asymp, c.5pl, hill, g.5pl){
    f <- c.5pl * (((inf.x.asymp - small.x.asymp) / 
                       (y - small.x.asymp))^(1/g.5pl) - 1)^(1 / hill)
    names(f) <- "x.hat"
    return(f)
} 

#' <h1 id="diagnostic-plots"> Diagnostic plots for non-linear regression models: plotDiag()</h1>

#' Plot data with fitted regression line and standardized residual plot
#' <h2>Class .nls</h2>
# ------------------- Function: plotDiag.nls() ----------------------------
# a wrapper for fitted curve and residual plots
plotDiag.nls <- function(nlsLM.model, title.top){
    par(mfcol=c(1, 2), oma = c(0.5, 0.5, 2, 0))
    # adapted from Brandon Greenwell's investr functions
    data <- eval(nlsLM.model$data)
    x.names <- intersect(all.vars(formula(nlsLM.model)[[3]]), colnames(data))
    y.names <- all.vars(formula(nlsLM.model)[[2]])
    x <- data[, x.names]  # extract predictor columns
    x.nz.min <- min(x[x!=0])
    # Display purposes, we cheat a little to get the zero calibrators included
    # on the log(x) plot
    x.fix <- ifelse(x <= 0, x.nz.min/5, x)
    break.x <- x.nz.min/4
    y <- data[, y.names]  # extract response columns
    # Plot data and fitted curve
    plot(x.fix, y, log = "x", main = "data and fitted curve", pch = 20,
         ylab = "Response", xlab = "log(Concentration)", font.main = 3)
    grid()
    curve(M.4pl(x, coef(nlsLM.model)[[1]], coef(nlsLM.model)[[2]], 
                coef(nlsLM.model)[[3]], coef(nlsLM.model)[[4]]), add = T)
    # Technically, we should not include the zero-calibrators on a log plot,
    # but it's nice to have for visualizing the results. This line inserts a
    # break in the x-axis as in Dudley et al (1985)
    axis.break(1, break.x, brw = 0.05)
    # Plot standardised weighted residuals
    # [add ifelse condition for weighted and unweighted models (title)]
    std.w.resid <- summary(nlsLM.model)$resid/sd(summary(nlsLM.model)$resid)
    plot(predict(nlsLM.model), std.w.resid, ylab = "std residuals (in SDs)", 
         xlab = "fitted response values", pch = 20, 
         main = "standardized residuals", font.main = 3)
    # Horizontal lines at y=0 and +/- 2SD
    abline(h = 0, lty = 3, col = "red")
    abline(h = 2, lty = 3)
    abline(h = -2, lty = 3)
    title(main = title.top, outer = TRUE)
    par(mfcol=c(1, 1))
}
# ------------------------ end -------------------------------------------

#' <h2>Class irls</h2>
# ------------------- Function: plotDiag.irls() ----------------------------
# a wrapper for fitted curve and residual plots
plotDiag.irls <- function(irls.model, title.top){
    # title.top <- "IRLS 4PL calibration model for O'Connell's ELISA: w2.4pl"
    par(mfcol=c(1, 2), oma = c(0.5, 0.5, 2, 0))
    # adapted from Brandon Greenwell's investr functions
    data <- irls.model$orig.data
    x.names <- intersect(all.vars(formula(irls.model$end.model)[[3]])
                         , colnames(data))
    y.names <- all.vars(formula(irls.model$end.model)[[2]])
    x <- data[, x.names]  # extract predictor columns
    x.nz.min <- min(x[x!=0])
    # Display purposes, we cheat a little to get the zero calibrators included
    # on the log(x) plot
    x.fix <- ifelse(x <= 0, x.nz.min/5, x)
    break.x <- x.nz.min/4
    y <- data[, y.names]  # extract response columns
    # Plot data and fitted curve
    plot(x.fix, y, log = "x", main = "data and fitted curve", pch = 20,
         ylab = "Response", xlab = "log(Concentration)", font.main = 3)
    grid()
    curve(M.4pl(x, coef(irls.model$end.model)[[1]]
                , coef(irls.model$end.model)[[2]]
                , coef(irls.model$end.model)[[3]]
                , coef(irls.model$end.model)[[4]])
          , add = T)
    axis.break(1, break.x, brw = 0.05)
    std.w.resid <- summary(irls.model$end.model)$resid/
        sd(summary(irls.model$end.model)$resid)
    plot(predict(irls.model$end.model), std.w.resid
         , ylab = "std residuals (in SDs)"
         , xlab = "fitted response values"
         , main = "standardized (weighted) residuals"
         , font.main = 3, pch = 20)
    abline(h = 0, lty = 3, col = "red")
    abline(h = 2, lty = 3)
    abline(h = -2, lty = 3)
    title(main = title.top, outer = TRUE)
    par(mfcol=c(1, 1))
}
# ------------------------ end -------------------------------------------

#'<h1 id="irls-nls">IRLS.nls</h1>
#'
#' <h2 id="irls-nls-4pl">Class 4pl</h1>

# ------------------- Algorithm: irls ----------------------------------------
# We need to estimate both the parameters of the 4PL function as well as the
# weight function. This can be done by iteratively applying the nlsLM function
# described above till the residual sum of squares does not reduce
# significantly. Below is a function that implements this iterative model
# fitting process. This is the same approach used in the GraphPad software
# program.

#######################################################
#
# 4PL iteratively reweighted LS procedure:
#
#  1. args: df, y, x, theta, start values
#  2. unweighted model (nlsLM)
#  3. get important output (y.curve, wss) using summary3()
#  4. calculate weights (uses y.curve and theta)
#  5. weighted nlsLM
#  6. d.wss: calculate change in wss (wss1 - wss2) / wss1
#  7. if d.wss > 0.01 repeat from (3)
#
#########################################################

# Use dot '.' to specify class
IRLS.4pl <- function(df, y = "od", x = "conc", theta, 
                     start = c(small.x.asymp = 0
                               , inf.x.asymp = 1
                               , inflec = 1000
                               , hill = -1)
)
{
    # Keep the original data set with the output object
    orig.data <- df
    # Function uses O'Connell's parameterization of theta
    theta2 <- theta/2
    # Insert variables into the 4pl formula 
    form.4pl <- paste(y, " ~ M.4pl(", x
                      , ", small.x.asymp, inf.x.asymp, inflec, hill)"
    )
    # Unweighted model
    nls0 <- nlsLM(as.formula(form.4pl), data = df, start = start)
    # Get the predicted responses
    y.curve <- predict(nls0)
    # Weighted sum of squares
    wss0 <- sum(summary(nls0)$resid^2)
    # 1st iteration   
    nls1 <- nlsLM(as.formula(form.4pl), data = df, start = start, 
                  weights = (1 / (y.curve^2)^theta2))
    wss1 <- sum(summary(nls1)$resid^2)
    # Percent change in the weighted sum of squares to control iterations
    # (count)
    d.wss <- abs(wss0 - wss1) / wss0
    count <- 1
    # Repeat fitting until WSS changes by less than 0.5%
    while (d.wss > 0.005){
        count  <- count + 1
        y.curve <- predict(nls1)
        nls1 <- nlsLM(as.formula(form.4pl), data = df, start = start, 
                      weights = (1 / (y.curve^2)^theta2))
        d.wss <- abs(wss1 - sum(summary(nls1)$resid^2)) / wss1
        wss1 <- sum(summary(nls1)$resid^2)
    }
    return(list(orig.data = orig.data, start.model = nls0, cycles = count
                , end.model = nls1))
}
# --------------------- end -------------------------------------------- 

#' <h2>summaryIRLS</h2>
# ------------------ Function: summaryIRLS() ----------------------------
# An irls results wrapper
summaryIRLS <- function(irls.model){
    # irls.model <- w2.4pl
    cat("\nThe unweighted model:\n")
    print(summary(irls.model$start.model))
    cat("---------------------------------------------------")
    cat("\nThe weighted sum of squares was stable after", 
        irls.model$cycles, "cycles\n\n")
    cat("---------------------------------------------------")
    cat("\nThe final model:\n")
    print(summary(irls.model$end.model))
    plot(log(unique(irls.model$orig.data$conc))
         , unique(predict(irls.model$start.model))
         , type = 'b', col = "grey"
         , ylab = "Fitted Response", xlab = "log(Concentration)", 
         main = "IRLS: unweighted and final weighted")
    points(log(unique(irls.model$orig.data$conc))
           , unique(predict(irls.model$end.model))
           , type = 'b', pch = 19, col = "red")
    legend(1, 0.9, legend = c("Unweighted", "Final weighted"), lty = 1, 
           col = c("grey", "red"))
    
}
# ------------------ end ------------------------------------------------

#' <h1 id="inv-pred">Inverse prediction functions</h1>

#' <h2 id="sdXhat">sdXhat</h2>

# -------------------- Function: sdXhat() class 4pl -------------------------
# The following function returns a data frame of triplets: a range of
# response values (`yp`), corresponding predicted concentration (`xp`)
# and the standard deviation of the predicted concentration (`sd.xp`).
# Derive var(x) from calibration curve model
# Adapted from S-PLUS code at <http://lib.stat.cmu.edu/S/calibration>
# Values from vcov(model) = unscaled * sigma^2 but sumary(model)$cov.unscaled
# is what we need: O'Connell p.103 (left column, about 1/2 page): "denotes the
# estimated covariance matrix for [beta-hat], unscaled by [sigma-hat]..."


# conf is confidence level for prediction interval
sdXhat.4pl <- function(irls.model 
                       # request theta from user since I do not know how to 
                       # get theta back out of object
                       , theta 
                       , m = 3  # check this
                       , vlen = 700){
    # model.sum is a irls.4pl() object (from above)
    model <- irls.model$end.model
    # theta <- theta.ocon.lit
    theta2 <- theta/2
    # Get some information from the original data    
    data <- irls.model$orig.data
    x.names <- intersect(all.vars(formula(model)[[3]]), colnames(data))
    y.names <- all.vars(formula(model)[[2]])
    x <- data[, x.names]  # extract predictor columns
    y <- data[, y.names]  # extract response columns    
    # Gather the bits and pieces
    # corresponding t value for requested confidence level 
    degree.freedom <- summary(model)$df[2]
    cov.un  <- summary(model)$cov.unscaled   # unscaled covariance matrix
    # O'Connell's parametrerisation for ascending curves is different
    # They keep beta positive and switch a and d
    b       <- coef(model)
    # sample size, n
    n       <- length(x)   
    # Setting the starting point for the grid
    xpstart <- min(c(0.0005, min(x[x>0])))      
    # x values for grid
    xp      <- c(seq(xpstart, b[[3]], length = round(vlen / 2, 0)), 
                 seq(b[[3]], max(x), length = round(vlen / 2, 0)))
    # y values for grid
    yp      <- as.vector(M.4pl(xp, b[1], b[2], b[3], b[4]))
    # The derivatives
    dh.dy <- xp * (b[1]-b[2])/(b[4]*(yp - b[1]) * (b[2] - yp))
    dh.db1 <- xp/(b[4]*(yp - b[1]))
    dh.db2 <- xp/(b[4]*(b[2] - yp))
    dh.db3 <- xp/b[3]
    dh.db4 <- (-xp/(b[4]*b[4])) * log((b[2]-yp)/(yp-b[1]))
    # compute the estimated variance of the calibration estimate xp
    # sigma2 is the mean variance. In weighted models it is scaled by weights
    sigma2 <-  summary(model)$sigma^2  
    # The following corresponds to equation on p.111 of O'Connell (1993)
    # Note the Var(y) part:
    # Var(y) = sigma2 * (yp^theta) 
    # Our parameterization (from weights) uses y.curve^theta, not ^2*theta
    # If using an outside theta based on variance function as function of SD,
    # not var, like in O'Connell, multiply by 2 first
    var.xnot.hat <- (dh.dy*dh.dy) * sigma2 * (yp^2)^theta2 / m +
        sigma2 * (dh.db1 * (  dh.db1 * cov.un[1,1]
                              + dh.db2 * cov.un[2,1]
                              + dh.db3 * cov.un[3,1]
                              + dh.db4 * cov.un[4,1])
                  + dh.db2 * (  dh.db1 * cov.un[1,2]
                                + dh.db2 * cov.un[2,2]
                                + dh.db3 * cov.un[3,2]
                                + dh.db4 * cov.un[4,2])
                  + dh.db3 * (  dh.db1 * cov.un[1,3]
                                + dh.db2 * cov.un[2,3]
                                + dh.db3 * cov.un[3,3]
                                + dh.db4 * cov.un[4,3])
                  + dh.db4 * (  dh.db1 * cov.un[1,4]
                                + dh.db2 * cov.un[2,4]
                                + dh.db3 * cov.un[3,4]
                                + dh.db4 * cov.un[4,4]))
    # Covert to standard deviation
    sd.xp <- sqrt(var.xnot.hat)
    # Gather yp and xp (grid) plus sd.xp into a data.frame
    inv.grid <- data.frame(yp, xp, sd.xp)
    # Drop any rowns containing NAs or infinite values
    inv.grid <- inv.grid[is.finite(inv.grid$sd.xp), ]
    # head(inv.grid, 10)
    return(list(inv.grid = inv.grid, model.degree.freedom = degree.freedom, 
                model.sigma2 = sigma2))
}
# --------------------- end ------------------------------

#' <h2 id="predictconc-4pl">predictConc.4pl</h2>

# ------------------ Function: predictConc() class 4pl -------------------
# Accepts a sdXhat.4pl object (such as ocon.grid) and new response
# observation(s)
# Each new response is the average of any M replicates 
# Default is single observation (M = 1)
predictConc.4pl <- function(sdXhat.object
                            , conf = 0.95
                            , M = 1
                            , y.new){
    # y.new <- 0.18
    # sdXhat.object <- ocon.grid
    # Need dplyr package for lead()
    require(dplyr)
    # Rename grid
    d <- unique(sdXhat.object$inv.grid)
    # ---- Interpolate new xp for y.new ------
    d$y.diff <- (d$yp - y.new)
    # Get next y.diff
    d$y.offset <- lead(d$y.diff)
    # Get next xp
    d$x.offset <- lead(d$xp)
    # d[7:17, ]
    # Intercept a for linear segments 
    # where line xp = a + (delta xp)/(delta y.diff) * y.diff
    d$a <- d$xp - d$y.diff*(d$x.offset - d$xp)/(d$y.offset - d$y.diff)
    # Segment closest on left to y.diff = 0
    closest <- max(d$y.diff[d$y.diff <= 0])
    # Corresponding x values
    x.est <- d$a[d$y.diff == closest]
    x.est.sd <- d$sd.xp[d$y.diff == closest]
    # Critical values for intervals
    # corresponding t value for requested confidence level 
    tcrit <- qt ((conf + 1) / 2, sdXhat.object$model.degree.freedom)
    # prediction interval
    x.est.lpl <- x.est - tcrit * x.est.sd * sqrt(1 + 1/M)
    x.est.upl <- x.est + tcrit * x.est.sd * sqrt(1 + 1/M)
    pred.int <- c(x.est.lpl, x.est.upl)
    # confidence interval
    x.est.lcl <- x.est - tcrit * x.est.sd * sqrt(1/M)
    x.est.ucl <- x.est + tcrit * x.est.sd * sqrt(1/M)
    conf.int <- c(x.est.lcl, x.est.ucl)
    return(list(estimate = x.est, conf.int = conf.int, pred.int = pred.int))
}
# --------------------- end ------------------------------

