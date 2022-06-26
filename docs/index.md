1. Reporte el error de predicción aparente o por resubstitución.
2. Estime el error de predicción por k-fold cross validation. Experimente por lo menos tres valores diferentes de k y B > 100 repeticiones. Compárelo con el error de entrenamiento, i.e. la suma de residuos al cuadrado obtenidos con el modelo ajustado con todas las observaciones. Comente sobre los resultados obtenidos.

**Respuesta:**

El error de predicción de un modelo de regresión lineal con variable respuesta Y y p predictores es el conocido ECM:

$$ error_{pred} = \sum_{i=1}^{n}\dfrac{(y_i - \hat{y}_i)^2}{n-p-1} = ECM$$
El de un modelo maás general como el de regresión logística o de discriminante, el error de predicción se le conoce como error
aparente o por resubstitución (training error with full sample):

$$ error_{aparente} = \sum_{i=1}^{n} \dfrac{(y_i - \hat{y}_i)^{2}}{n} $$
En regresión: 

$$ error_{aparente} = \dfrac{n-p-1}{n}\cdot ECM$$
