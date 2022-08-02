
library(glmnet)
library(boot)
library(caret)

# Porter 
porter <- read.csv("C:\\Users\\danie\\Desktop\\Tarea Bayesiana\\Proyecto Final\\porter.csv",
                  header=TRUE, stringsAsFactors=FALSE)
porter <- porter[,-c(1)]


MSE.porter.models <- matrix(NA,10,3)

for (i in 1:10){ set.seed(i)
  folds <- createFolds(factor(porter$review_overall), k = 10, list = FALSE)
  
  train <- porter[folds != i,]
  test <-porter[folds == i,]
  
  dumm.porter <- glm(data = train, 
                     review_overall 
                     ~ review_aroma 
                     + review_palate 
                     + review_appearance  
                     + review_taste) 
  
  glm.porter <- glm(data = train, 
                    review_overall 
                    ~ review_aroma 
                    + review_palate 
                    + review_appearance  
                    + review_taste 
                    + review_aroma:review_appearance
                    + review_aroma:review_palate
                    + review_aroma:review_taste 
                    + review_palate:review_appearance
                    + review_palate:review_taste
                    + review_appearance:review_taste)
  
  glm.porter.AIC <- step(glm.porter, criterion = "AIC")
  
  MSE.1 <- sum((predict(dumm.porter, test)-test$review_overall)**2)/ nrow(test)
  MSE.2 <- sum((predict(glm.porter, test)-test$review_overall)**2)/ nrow(test)
  MSE.3 <- sum((predict(glm.porter.AIC, test)-test$review_overall)**2)/ nrow(test)
  
  MSE.porter.models[i,] <- c(MSE.1,MSE.2,MSE.3)
}

porter.final.MSE <- apply(MSE.porter.models, 2, mean)

# Stout
stout <- read.csv("C:\\Users\\danie\\Desktop\\Tarea Bayesiana\\Proyecto Final\\stout.csv",
                   header=TRUE, stringsAsFactors=FALSE)
stout <- stout[,-c(1)]

MSE.stout.models <- matrix(NA,10,3)

for (i in 1:10){ set.seed(i)
  folds <- createFolds(factor(stout$review_overall), k = 10, list = FALSE)
  
  train <- stout[folds != i,]
  test <-stout[folds == i,]
  
  dumm.stout <- glm(data = train, 
                     review_overall 
                     ~ review_aroma 
                     + review_palate 
                     + review_appearance  
                     + review_taste) 
  
  glm.stout <- glm(data = train, 
                    review_overall 
                    ~ review_aroma 
                    + review_palate 
                    + review_appearance  
                    + review_taste 
                    + review_aroma:review_appearance
                    + review_aroma:review_palate
                    + review_aroma:review_taste 
                    + review_palate:review_appearance
                    + review_palate:review_taste
                    + review_appearance:review_taste)
  
  glm.stout.AIC <- step(glm.stout, criterion = "AIC")
  
  MSE.1 <- sum((predict(dumm.stout, test)-test$review_overall)**2)/ nrow(test)
  MSE.2 <- sum((predict(glm.stout, test)-test$review_overall)**2)/ nrow(test)
  MSE.3 <- sum((predict(glm.stout.AIC, test)-test$review_overall)**2)/ nrow(test)
  
  MSE.stout.models[i,] <- c(MSE.1,MSE.2,MSE.3)
}

stout.final.MSE <- apply(MSE.stout.models, 2, mean)


# Print Final Values
porter.final.MSE
stout.final.MSE