
source("https://bioconductor.org/biocLite.R")
biocLite("RBGL")

library(RBGL)

if(!require("gRbase", character.only = TRUE, quietly = TRUE)) {
  install.packages("gRbase")
  library("gRbase", character.only = TRUE)
}


if(!require("gRain", character.only = TRUE, quietly = TRUE)) {
  install.packages("gRain")
  library("gRain", character.only = TRUE)
}

if(!require("Rgraphviz", character.only = TRUE, quietly = TRUE)) {
  install.packages("Rgraphviz")
  library("Rgraphviz", character.only = TRUE)
}


source("http://bioconductor.org/biocLite.R")
biocLite("Rgraphviz")

library(Rgraphviz)

if(!require("bnlearn", character.only = TRUE, quietly = TRUE)) {
  install.packages("bnlearn")
  library("bnlearn", character.only = TRUE)
}


library(bnlearn)


# http://www.di.fc.ul.pt/~jpn/r/bayesnets/bayesnets.html

yn = c("yes","no")



# specify the CPTs
node.C <- cptable(~ C, values=c(1, 99), levels=yn)
node.T1 <- cptable(~ T1 + C, values=c(9,1,2,8), levels=yn)
node.T2 <- cptable(~ T2 + C, values=c(9,1,2,8), levels=yn)

plist <- compileCPT(list(node.C, node.T1, node.T2))
plist
plist$C

# create network
bn.cancer <- grain(plist)
summary(bn.cancer)

# The marginal probability for each variable:
querygrain(bn.cancer, nodes=c("C", "T1", "T2"), type="marginal")

# The joint probability P(C,T1):
querygrain(bn.cancer, nodes=c("C","T1"), type="conditional")

# The conditional P(not C | not T1)
bn.cancer.2 <- setFinding(bn.cancer, nodes=c("T1"), states=c("no")) 
querygrain(bn.cancer.2, nodes=c("C"))

plot(bn.cancer.2)


dag.can <- dag(~ CAD:Smoker:Inherit:Hyperchol + 
                 AngPec:CAD + 
                 Heartfail:CAD + 
                 QWave:CAD)
plot(dag.cad)




data("cad1")
head(cad1)


#  1. add evidence to the net
bn.cancer.1 <- setFinding(bn.cancer, nodes=c("T2"), states=c("yes")) 
#  2. query the new net
querygrain(bn.cancer.1, nodes=c("T1"))

dag.cad <- dag(~ CAD:Smoker:Inherit:Hyperchol + 
                 AngPec:CAD + 
                 Heartfail:CAD + 
                 QWave:CAD)
plot(dag.cad)

##Blearn - 

data(alarm)
head(alarm, n=1) 
alarm.struct <- iamb(alarm, test = "x2")
graphviz.plot(dag.alarm, highlight = list(arcs = arcs(alarm.struct)))

