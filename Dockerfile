# Shiny server with some packages installed
FROM rocker/shiny
MAINTAINER Mark Edmondson <mark@iihnordic.com>
RUN sudo apt-get update && apt-get install -y \
         nano \
         libssl-dev \
         libxml2-dev

# So nano works
ENV TERM xterm

# custom packages
RUN sudo su - -c "R -e \"install.packages(c('DT','zoo','devtools','shinydashboard','dplyr','plotrix','ggplot2','lubridate','stringr'), repos='http://cran.rstudio.com/')\""
RUN sudo su - -c "R -e \"devtools::install_github('MarkEdmondson1234/googleAuthR')\""
RUN sudo su - -c "R -e \"devtools::install_github('MarkEdmondson1234/googleAnalyticsR_public')\""
RUN sudo su - -c "R -e \"devtools::install_github('MarkEdmondson1234/iihAutomatedReporting')\""
RUN sudo su - -c "R -e \"devtools::install_github('rstudio/shinyapps')\""
