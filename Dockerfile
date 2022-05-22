FROM rocker/shiny

RUN install2.r shiny 
RUN install2.r shinyWidgets 
RUN install2.r data.table 
RUN install2.r devtools
RUN install2.r DT 
RUN install2.r ggplot2 
RUN install2.r plotly
RUN install2.r dplyr
RUN install2.r lubridate
RUN install2.r viridis
RUN install2.r remotes
RUN install2.r collapsibleTree
RUN install2.r shinydashboard
RUN install2.r logger
RUN install2.r viridisLite
RUN installGithub.r -u FALSE tidyverse/tidyverse

RUN mkdir /app
COPY *.R /app/

EXPOSE 3838
CMD ["R", "-e", "shiny::runApp('/app', port = 3838, host = '0.0.0.0')"]
