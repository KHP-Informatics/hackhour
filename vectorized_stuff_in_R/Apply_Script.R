# [DESCRIPTION] Script used for Apply function workshop
# [AUTHOR] Richard Pugh (ed. Amos Folarin)
# [KEYWORDS] apply, function, sapply, lapply, tapply, aggregate, by

# Set working directory
setwd("D:\\Mango\\Marketing\\LondonR\\Sep13\\Apply Workshop")


#Loops and such control flow exists in R but are typically seen less than might be expected
for(x in 1:10)
{
    print(x)
}

# As a data analysis tool and functional programming language, almost everything in R is vectorized.
# The principle goal here is to speed up and clarify the types of code you'll most likely be writing 
#e.g. 
#outer(x,y, FUN) function
#Use FUN on every pairwise combination of x and y.


# Try to find the "apply" family of functions ...
apropos("apply")

### apply

# Arguments to apply
args(apply)

# Simple examples
myMatrix <- matrix( rpois(30, 3), 5)
myMatrix
apply(myMatrix, 1, min)  # Row minima
apply(myMatrix, 2, max)  # Column maxima

# Mix with plots
bigMat <- matrix( rnorm(400), 20 )
matplot(bigMat, type = "l", lty = 1, col = "grey")
lines(1:20, apply(bigMat, 1, min), col = "red")
lines(1:20, cummax(apply(bigMat, 1, max)), col = "blue", type = "s")

# Applying over 2 dimensions
myMatrix
apply(myMatrix, 1:2, mean)

# Applying over an array
myArray <- array( rpois(18, 3), dim = c(3, 3, 2))
myArray
apply(myArray, 3, diag)
apply(myArray, 1:2, max)

# Passing additional arguments
myMatrix[2, 2] <- myMatrix[4, 2] <- NA
myMatrix
apply(myMatrix, 2, mean)
apply(myMatrix, 2, mean, na.rm = TRUE)

# Using custom functions
myFun <- function(x) quantile(x, .95)
myMatrix <- matrix( rnorm(20^2), 20 )
q95 <- apply(myMatrix, 1, myFun)
q95

matplot(myMatrix, type = "l", lty = 1, col = "grey")
lines(1:20, q95, col = "red")

# A nice example: Analytical VaR of a single asset
aVar95 <- function(days, value, mu, sigma) - (mu - qnorm(.95) * sigma) * value * sqrt(days)
plot(1:21, aVar95(1:21, 1000000, .003, .03)/1000, type = "l", xlab = "Day",
     ylab = "Analytic VAR: Lower 5% interval (KGBP)", col = "red",
     main = "Analytic VAR calculated for asset price £1m", lwd = 2)

require(MASS)  # Load the MASS library
theCov <- cbind(c(.00001, 1.13e-07), c( 1.13e-07, .00001) ) 
varDist <- mvrnorm(100, c(.003, .03), theCov)  # Calculate parameters
av95s <- apply(varDist, 1, function(pars) aVar95(1:21, 1000000, pars[1], pars[2])/1000)
matplot(1:21, av95s, type = "l", col = "grey", lty = 1, xlab = "Day",
        ylab = "Analytic VAR: Lower 5% interval (KGBP)", 
        main = "Analytic VAR calculated for asset price £1m")
lines(1:21, aVar95(1:21, 1000000, .003, .03)/1000, col = "red", lwd = 2)

### lapply

# Arguments to lapply
args(lapply)

# Simple example
myList <- list(Pois = rpois(10, 3), Norm = rnorm(5), Unif = runif(5, 1, 10))
myList
lapply(myList, mean)

# Using split
tubeData <- read.csv("tubeSubset.csv")
head(tubeData)
with(tubeData, split(Excess, Line))

# Split and lapply
lapply(with(tubeData, split(Excess, Line)), mean)

# Split with lapply (applied to data frames)
lapply(split(tubeData, tubeData$Line), 
       function(df) lm(log(Excess) ~ Month, data = df))

lapply(1:5, rnorm)

# Split processing using lapply
largeXs <- lapply(split(tubeData, tubeData$Line), function(df) {
  xSd <- sd(df$Excess)
  xMean <- mean(df$Excess)
  subset(df, Excess > xMean + 2 * xSd)
})
largeXs
do.call("rbind", largeXs)

### sapply

# Simple sapply examples
myList <- list(Pois = rpois(10, 3), Norm = rnorm(5), Unif = runif(5, 1, 10))
myList
lapply(myList, mean)
sapply(myList, mean)

# Using split and sapply
sapply(with(tubeData, split(Excess, Line)), mean)

t(sapply(split(tubeData, tubeData$Line), 
       function(df) coef(lm(log(Excess) ~ Month, data = df))))

head(tubeData, 15)

# A bootstrap style example using sapply
nrow(iris)
pairs(iris)

myLm <- lm(Petal.Length ~ Petal.Width, data = iris)
with(iris, plot(Petal.Width, Petal.Length))
abline(myLm, col = "red")

nSamples <- sample(4:150, 1000, TRUE)
theSlopes <- sapply(nSamples, function(i) {
  coef(lm(Petal.Length ~ Petal.Width, 
          data = iris, subset = sample(1:nrow(iris), i)))[2]
})
plot(nSamples, theSlopes, pch = 4, xlab = "Number of Samples", 
     ylab = "Slope of Regression")
abline(h = coef(myLm)[2], col = "red", lwd = 2)

# sapply with data frames
sapply(tubeData, class)

numIris <- sapply(iris, class) == "numeric"
sapply(iris [ numIris ], mean)

### tapply

# tapply arguments
args(tapply)

# Simple example of tapply
head(tubeData)
with(tubeData, tapply(Excess, Line, mean))
with(tubeData, tapply(Excess, list(WhenOpen, Length), mean))

# tapply vs sapply + split
with(tubeData, tapply(Excess, Line, mean))
with(tubeData, sapply(split(Excess, Line), mean))

# Returning multiple values
with(tubeData, tapply(Excess, Line, range))
with(tubeData, tapply(Excess, list(WhenOpen, Length), range))

### by

# Arguments it takes
args(by)

# Simple "by" example
by( tubeData, tubeData$Line, head )

# The trouble with "by" .....
byOutput1 <- by( tubeData, tubeData$Line, head )
class(byOutput1)     # What is the class?
names(byOutput1)     # What are the names of the object?
byOutput1$Victoria   # Treat it like a list

byOutput2 <- by( tubeData, list(tubeData$WhenOpen, tubeData$Length), 
                 function(df) lm(log(Excess) ~ Month, data = df))
class(byOutput2)
names(byOutput2)     # What are the names of the object?
print.default(byOutput2)

### aggregate

# Arguments
args(aggregate.data.frame)

# Simple aggregate example
aggregate( list(MeanExcess = tubeData$Excess),
           tubeData[c("WhenOpen", "Type")], mean)

# Aggregate data
q5 <- aggregate( list(q5 = tubeData$Excess),
           tubeData["Line"], quantile, probs = .05)
q50 <- aggregate( list(q50 = tubeData$Excess),
                 tubeData["Line"], quantile, probs = .5)
q95 <- aggregate( list(q95 = tubeData$Excess),
                  tubeData["Line"], quantile, probs = .95)
merge(merge(q5, q50), q95)

# Arguments to aggregate.formula
args(stats:::aggregate.formula)

# Using formulae
aggregate(Excess ~ Line, tubeData, quantile, .95)
aggregate(Excess ~ WhenOpen + Type, tubeData, mean)

### Other apply functions

### eapply
e <- new.env()
e$a <- rnorm(10)
e$b <- sample(LETTERS[1:3], 10, TRUE)
e$c <- tubeData

eapply(e, summary)

### mapply

aVar95 <- function(days, value, mu, sigma) {
  - (mu - qnorm(.95) * sigma) * value * sqrt(days)
}

aVars <- mapply(aVar95, rnorm(10, .03, .001), 
          rnorm(10, .003, .00001), MoreArgs = list(days = 1:21, sigma = 1))

matplot(1:21, aVars, type = "l", lty = 1, ylab = "95% Loss", xlab = "Days")

### rapply

# "Recursively" calls lapply
myList <- list(Pois = rpois(5, 3), Norm = rnorm(5, 10), Unif = runif(5))
myList
rapply(myList, log)
rapply(myList, log, how = "list")

### vapply
mySummary <- function(vec) {
  c(mean(vec), median(vec), sd(vec), max(vec), min(vec))
}
sapply(myList, mySummary)
vapply(myList, mySummary, c(Mean = 0, Median = 0, SD = 0, Max = 0, Min = 0))

# replicate
replicate(6, rnorm(5))
par(mfrow = c(2, 4))
replicate(8, hist(rnorm(100), col = "orange"))


