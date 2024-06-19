# Air Quality of Monterrey (Mexico): ETL-EDA

<p align="center">
  <img src="https://github.com/Jimenamatzui98/Portfolio/blob/3967b2f6c5b5519ab224908de0280d0f3948b440/DataScience_Diploma_FinalProject/Images/Contaminacion.jpeg" alt="Contaminacion" width="500">
</p>

## Índice

1. [Description](#descripción)
2. [Extraction](#extracción)
3. [Transformation](#transformación)
4. [Load](#carga)
5. [Consultas y analisis](#consultas)

## Description of the project ✍️

This is my final project for the Data Science Diploma for Bedu, Tecnolochicas. This project aims to integrate the knowledge from the 3 modules of the diploma, using Python and libraries such as Pandas, NumPy, MatplotLib, Seaborn, Scikit-learn, folium, etc.

### Restrictions ⛔ 

- The information has to come from 3 different sources (URLs) 
- We have to use 2 methods of data extraction (csv, api,  rss, web scrapping, database)

### Context 🧭

The State of Nuevo León has an area of ​​64,156 km2 and is located in the northeast of Mexico. It has a dry climate with an average annual temperature of 20°C and an average yearly precipitation of 650mm (Secretaría de Comercio, 2018). Monterrey has 1,139,417 inhabitants, and it concentrates almost the same amount as 18 municipalities in the State of Nuevo León, according to the INEGI list (2015), this is explained due to its economic activity that stands out in the entire State with 39.8% of the monetary units, 43.2% of the employed personnel and 35.4% of the total gross production.

These socioeconomic conditions, coupled with demographic growth, have influenced the environmental conditions in this municipality, mainly the air quality. According to the Management Program to Improve Air Quality in the State of Nuevo León 2016-2025 (ProAire) [^1], the deterioration of air quality depends on multiple factors, among the most important are economic activity related to the consumption of fossil fuels, the type of fuel, the mobility, quality of roads, and means of transportation. Another factor is the physiographic characteristics since the orography and climatic conditions affect the dispersion or accumulation of contaminants in a given area. 

<p align="center">
  <img src="https://github.com/Jimenamatzui98/Portfolio/blob/543e3940a1a4b1051a2467d27b6e38e2e3200697/DataScience_Diploma_FinalProject/Images/Monterrey.webp" alt="Monterrey" width="500">

Because of this, the Monterrey Metropolitan Area( MMA) uses an environmental monitoring system called the Sistema Integral de Monitoreo Ambiental (SIMA), which keeps track of air quality based on the criteria pollutants (CO, SO2, NO𝑥, O3, PM10, and PM2.5) and publishes a monthly report of the results. [^2] Additionally, the federal institution  database provides an API that gathers the data from the different state institutions that monitor these criteria in the country. [^3] 

In this project, we will be exploring the data from this API and comparing it with the reports of the SIMA, additionally, finding correlations and fitting the data in Machine Learning Models. 






#### footnotes: 
[^1]: https://www.redalyc.org/journal/3761/376168604013/html/
[^2]: Aguirre-López, M.A.; Rodríguez-González, M.A.; Soto-Villalobos, R.; Gómez-Sánchez, L.E.; Benavides-Ríos, Á.G.; Benavides-Bravo, F.G.; Walle-García, O.; Pamanés-Aguilar, M.G. Statistical Analysis of PM10 Concentration in the Monterrey Metropolitan Area, Mexico (2010–2018). Atmosphere 2022, 13, 297. https://doi.org/10.3390/atmos13020297
[^3]: https://datos.gob.mx/busca/dataset/mediciones-de-contaminantes-del-sistema-nacional-de-informacion-de-la-calidad-del-aire
