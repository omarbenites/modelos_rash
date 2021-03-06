####################################
# Aplicaci�n con datos educacionales
####################################
rm(list=ls())

# Instalaci�n de paquetes
install.packages(c("foreign","ltm"))
install.packages("psych")
library(foreign)
library(ltm)
library(psych)

# Datos
#setwd()
matematica <- read.csv(file.choose(),T)
head(matematica)
#str(matematica)
matematica <-matematica[,2:43]

# descriptivos
describe(matematica)
# �Cu�les es el �tem con mayor tasa de acierto?
# �Cu�l es el �tem con menor tasa de acierto?
# En promedio cu�l es la tasa de acierto de la prueba?


###########################################################
# Modelo Rasch                                            #
###########################################################
mate.rasch <- rasch(matematica, constraint = cbind(length(matematica) + 1, 1))
summary(mate.rasch)

# ordena los par�metros desde el m�s f�cil al m�s dif�cil
coef(mate.rasch, prob = TRUE, order = TRUE)


# Extraer los parametros de dificultad y compararlos con las proporciones de aciertos 
mate.rasch$beta = -mate.rasch$coefficients[,1]

comp <- cbind(mate.rasch$beta,prop=colMeans(matematica))
plot(comp, col = "red", lwd = 2)

# Curva Caracter�stica del �tem (CCI)
plot(mate.rasch, legend = FALSE, lwd = 2,
     main="Curvas Caracter�sticas de los �tems (CCI)",
     xlab = "Habilidad en Matem�ticas",
     ylab = "Probabilidad",
     cex.main = 1.0, cex.lab = 0.75, cex = 0.75)

## CCI para el �tem m�s f�cil y el m�s dif�cil

plot(mate.rasch, legend = FALSE, lwd = 2,
     items = c(22,9),
     main="Curvas Caracter�sticas de los �tems (CCI)",
     xlab = "Habilidad en Matem�ticas",
     ylab = "Probabilidad",
     cex.main = 1.0, cex.lab = 0.75, cex = 0.75)

par(mfrow=c(1,2))

# Funci�n de Informaci�n de los Items
plot(mate.rasch, type = "IIC", annot= TRUE, lwd = 3,
     #items = c(1, 3),
     main="Funci�n de Informaci�n de los Items (FII)",
     xlab = "Habilidad en Matem�ticas",
     ylab = "Informaci�n",      
     cex.main = 2.0, cex.lab = 1.00, cex = 1.00)


# Funci�n de Informaci�n del Test
plot(mate.rasch, type = "IIC", items = 0, lwd = 3,
     main="Funci�n de Informaci�n del Test (FIT)",
     xlab = "Habilidad en Matem�ticas",
     ylab = "Informaci�n",      
     cex.main = 2.0, cex.lab = 1.00, cex = 1.00)
par(mfrow=c(1,1))

# C�lculo de la informaci�n (�rea bajo la curva) de la prueba
## Zona baja
info1 <- information(mate.rasch, c(-10, 0))
info1

## Zona alta
info2 <- information(mate.rasch, c(0, 10))
info2


# Habilidades
mate.rasch.habilidad <- factor.scores(mate.rasch)
head(mate.rasch.habilidad$score.dat[,45:46])
mate.rasch.habilidad$score <- mate.rasch.habilidad$score.dat[,45]

par(mfrow=c(2,1))
hab <-hist(mate.rasch.habilidad$score, col = "blue",
           xlim = c(-4,3),
           main = "Histograma de la habilidad en matem�ticas",
           xlab = "Habilidad en Matem�ticas"); hab

# Dificultades
dif <- hist(coef(mate.rasch), col = "red",
            xlim = c(-4,3),
            main = "Histograma de la dificultad de los �tems",
            xlab = "Dificultad del �tem"); dif



