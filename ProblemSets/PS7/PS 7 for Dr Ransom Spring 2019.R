# PS 7
## ALex Hinshaw
### 12 March 2019

Set up and stargazer

```{r}
install.packages("mice")
install.packages("stargazer")
install.packages("magrittr")
library(magrittr)
library(mice)
library(stargazer)
library(dplyr)
library(tidyverse)
wages <- read.csv("wages.csv")
stargazer(wages)
```

Drop NA tenure and NA hgc

```{r}
wages %<>% drop_na(hgc,tenure)

```

LISTWISE DELETION

```{r}
wages %<>% mutate(tenure.sq = tenure^2)
wages.listwise <- lm(logwage ~ hgc + college + tenure + I(tenure^2) + age + married, data=wages, na.action=na.omit)
summary(wages.listwise)
```

MEAN IMPUTATION

```{r}
wages$logwage.mean.imp <- wages$logwage
wages %<>% mutate(logwage.mean.imp = logwage)
wagebar <- mean(wages$logwage,na.rm=TRUE)
wages$logwage.mean.imp[is.na(wages$logwage.mean.imp)] <- wagebar
parms.mean.imp <- lm(logwage.mean.imp ~ hgc + college + tenure + I(tenure^2) + age + married, data=wages, na.action=na.omit)
summary(parms.mean.imp)
```

REGRESSION IMPUTATION

```{r}
wages$logwage.pred.imp <- wages$logwage
test <- lm(logwage.mean.imp ~ hgc + college + tenure + I(tenure^2) + age + married, data=wages, na.action=na.exclude)
wages$pred <- NA
wages$pred[!is.na(wages$hgc) & !is.na(wages$tenure)] <- predict(test,wages,na.action=na.exclude)
wages$logwage.pred.imp[is.na(wages$logwage)] <- wages$pred[is.na(wages$logwage)]
parms.regression.imp <- lm(logwage.pred.imp ~ hgc + college + tenure + I(tenure^2) + age + married, data=wages, na.action=na.omit)
summary(parms.regression.imp)

stargazer(wages.listwise,parms.mean.imp,parms.regression.imp)
```

MICE

```{r}
wages.imp = mice(wages[,c("logwage","hgc","college","tenure","age","married")], seed = 123456, m=20)
fit = with(wages.imp, lm(logwage ~ hgc + college + tenure + I(tenure^2) + age + married))
parms.mice.imp <- pool(fit)
stargazer(parms.mean.imp)
```