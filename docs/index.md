## Welcome to GitHub Pages

\begin{itemize}

\item[1.] Reporte el error de predicción aparente o por resubstitución.
\item[2.] Estime el error de predicción por k-fold cross validation. Experimente por lo menos tres valores diferentes de k y B > 100 repeticiones. Compárelo con el error de entrenamiento, i.e. la suma de residuos al cuadrado obtenidos con el modelo ajustado con todas las observaciones. Comente sobre los resultados obtenidos.

\end{itemize}

**Respuesta:**

El error de predicción de un modelo de regresión lineal con variable respuesta Y y p predictores es el conocido ECM:

$$ error_{pred} = \sum_{i=1}^{n}\dfrac{(y_i - \hat{y}_i)^2}{n-p-1} = ECM$$
El de un modelo maás general como el de regresión logística o de discriminante, el error de predicción se le conoce como error
aparente o por resubstitución (training error with full sample):

$$ error_{aparente} = \sum_{i=1}^{n} \dfrac{(y_i - \hat{y}_i)^{2}}{n} $$
En regresión: 

$$ error_{aparente} = \dfrac{n-p-1}{n}\cdot ECM$$


You can use the [editor on GitHub](https://github.com/danielrole/NN-Mathematical-Theory/edit/main/docs/index.md) to maintain and preview the content for your website in Markdown files.

Whenever you commit to this repository, GitHub Pages will run [Jekyll](https://jekyllrb.com/) to rebuild the pages in your site, from the content in your Markdown files.

### Markdown

Markdown is a lightweight and easy-to-use syntax for styling your writing. It includes conventions for

```markdown
Syntax highlighted code block

# Header 1
## Header 2
### Header 3

- Bulleted
- List

1. Numbered
2. List

**Bold** and _Italic_ and `Code` text

[Link](url) and ![Image](src)
```

For more details see [Basic writing and formatting syntax](https://docs.github.com/en/github/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax).

### Jekyll Themes

Your Pages site will use the layout and styles from the Jekyll theme you have selected in your [repository settings](https://github.com/danielrole/NN-Mathematical-Theory/settings/pages). The name of this theme is saved in the Jekyll `_config.yml` configuration file.

### Support or Contact

Having trouble with Pages? Check out our [documentation](https://docs.github.com/categories/github-pages-basics/) or [contact support](https://support.github.com/contact) and we’ll help you sort it out.
