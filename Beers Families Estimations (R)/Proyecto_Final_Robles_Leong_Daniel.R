#install.packages (c ("rjags","coda"))

library("rjags")
library("coda")
library("dplyr") 
library(glmnet)
library(boot)
library(caret)


#_______________________________________________________________________________
################################################################################
# Best Subset Analisis

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
#_______________________________________________________________________________
################################################################################
# RJAGS

# Data
## Porter
porter <- read.csv("C:\\Users\\danie\\Desktop\\Tarea Bayesiana\\Proyecto Final\\porter.csv",
                   header=TRUE, stringsAsFactors=FALSE)
porter <- porter[,-c(1)]
## Stout
stout <- read.csv("C:\\Users\\danie\\Desktop\\Tarea Bayesiana\\Proyecto Final\\stout.csv",
                  header=TRUE, stringsAsFactors=FALSE)
stout <- stout[,-c(1)]

#_______________________________________________________________________________

apply(porter, 2, mean)
apply(porter, 2, sd)

# DEFINE the model based on BEST SUBSET MODEL
porter_model <- "model{  
        # Likelihood model for Y[i]  
        for(i in 1:length(Y)) {    
            Y[i] ~ dnorm(m[i], s^(-2))    
            m[i] <- a + b*X1[i] + c*X2[i] + d*X3[i] + e*X4[i] }  
        # Prior models for a, b, c, s
            a ~ dnorm(0, 5^(-2))
            b ~ dnorm(3.836, 0.581^(-2))
            c ~ dnorm(3.957, 0.507^(-2))
            d ~ dnorm(3.784, 0.631^(-2))
            e ~ dnorm(3.898, 0.636^(-2))
            s ~ dunif(0, 5)
        }"

# COMPILE the model
porter_jags <- jags.model(textConnection(porter_model), 
                          data = list(Y =  porter$review_overall,
                                      X1 = porter$review_aroma, 
                                      X2 = porter$review_appearance, 
                                      X3 = porter$review_palate,
                                      X4 = porter$review_taste),
                          inits = list(.RNG.name = "base::Wichmann-Hill", .RNG.seed = 10))

# SIMULATE the posterior    
porter_sim <- coda.samples(model = porter_jags, variable.names = c("a", "b", "c", "d", "e", "s"), n.iter = 10000)

# Store the chains in a data frame
porter_chains <- data.frame(porter_sim[[1]])

# PLOT the posterior    
plot(porter_sim)

summary(porter_sim)



# Simulate predictions under each parameter set
porter_chains <- porter_chains %>% 
  mutate(Y_pred = a + 3.5*b + 3*c +3.5*d + 4*e)

# Construct a density plot of the posterior 
ggplot(porter_chains, aes(x = Y_pred)) + 
  geom_density()

#_______________________________________________________________________________


apply(stout, 2, mean)
apply(stout, 2, sd)

# DEFINE the model based on BEST SUBSET MODEL
stout_model <- "model{  
        # Likelihood model for Y[i]  
        for(i in 1:length(Y)) {    
            Y[i] ~ dnorm(m[i], s^(-2))    
            m[i] <- a + b*X1[i] + c*X2[i] + d*X3[i] + e*X4[i] }  
        # Prior models for a, b, c, s
            a ~ dnorm(0, 5^(-2))
            b ~ dnorm(3.884, 0.584^(-2))
            c ~ dnorm(3.983, 0.521^(-2))
            d ~ dnorm(3.773, 0.661^(-2))
            e ~ dnorm(3.886, 0.667^(-2))
            s ~ dunif(0, 5)
        }"

# COMPILE the model
stout_jags <- jags.model(textConnection(stout_model), 
                          data = list(Y =  stout$review_overall,
                                      X1 = stout$review_aroma, 
                                      X2 = stout$review_appearance, 
                                      X3 = stout$review_palate,
                                      X4 = stout$review_taste),
                          inits = list(.RNG.name = "base::Wichmann-Hill", .RNG.seed = 10))

# SIMULATE the posterior    
stout_sim <- coda.samples(model = stout_jags, variable.names = c("a", "b", "c", "d", "e", "s"), n.iter = 10000)

# Store the chains in a data frame
stout_chains <- data.frame(stout_sim[[1]])

# PLOT the posterior    
plot(stout_sim)

summary(stout_sim)

# Simulate predictions under each parameter set
stout_chains <- stout_chains %>% 
  mutate(Y_pred = a + 3.5*b + 3*c +3.5*d + 4*e)

# Construct a density plot of the posterior
ggplot(stout_chains, aes(x = Y_pred)) + 
  geom_density()


#_______________________________________________________________________________
################################################################################
# SIMPLE LINEAR REGRESION

porter_u <- read.csv("C:\\Users\\danie\\Desktop\\Tarea Bayesiana\\Proyecto Final\\porter_users.csv",
                     header=TRUE, stringsAsFactors=FALSE)
stout_u <- read.csv("C:\\Users\\danie\\Desktop\\Tarea Bayesiana\\Proyecto Final\\stout_users.csv",
                    header=TRUE, stringsAsFactors=FALSE)

porter_u
stout_u

# Simple Linear Models
review_overall.lm <- lm(porter_u$porter_review_overall ~ stout_u$stout_review_overall)

review_palate.lm <- lm(porter_u$porter_review_palate ~ stout_u$stout_review_palate)
review_taste.lm <- lm(porter_u$porter_review_taste ~ stout_u$stout_review_taste)
review_appearance.lm <- lm(porter_u$porter_review_appearance ~ stout_u$stout_review_appearance)
review_aroma.lm <- lm(porter_u$porter_review_aroma ~ stout_u$stout_review_aroma)

#_______________________________________________________________________________
################################################################################
# Accuracy

predictions <- matrix(NA, nrow(stout_u), 4)
colnames(predictions) <- c("review_aroma", "review_appearance", 
                           "review_palate", "review_taste")

predictions[,1] <- predict(review_aroma.lm, stout_u[3])
predictions[,2] <- predict(review_appearance.lm, stout_u[4])
predictions[,3] <- predict(review_palate.lm, stout_u[5])
predictions[,4] <- predict(review_taste.lm, stout_u[6])


# Simulate predictions under each parameter set


#X1 = stout$review_aroma
#X2 = stout$review_appearance 
#X3 = stout$review_palate
#X4 = stout$review_taste


pred_fin <- c()

for (i in 1:nrow(predictions)){
  val <- predictions[i,]
  
  porter_chains <- porter_chains %>% 
    mutate(Y_pred = a + val[1]*b + val[2]*c +val[3]*d + val[4]*e)
  
  pred_fin[i] <- mean(porter_chains$Y_pred)}

predictions_vs_data <- (pred_fin - porter_u$porter_review_overall)**2
hist(predictions_vs_data)

mean(final_diferences)
sd(final_diferences)