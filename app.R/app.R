# app.R
# WeatherInformant - Kenyan Climate Dashboard
# Group X - Statistical Computing Project 2025/2026

library(shiny)
library(shinydashboard)
library(tidyverse)
library(plotly)
library(DT)
library(leaflet)
library(sf)
library(viridis)
library(lubridate)

getwd()

# --- Load Data ---
climate_data <- read.csv("data/climate_data.csv", stringsAsFactors = FALSE, check.names = FALSE)

# Standardize column names
names(climate_data) <- c("Year","Month","County_Name","tmean","tmax","tmin","Date","rainfall")

# Ensure Date is Date class
climate_data$Date <- as.Date(climate_data$Date, format="%m/%d/%Y")

# Add Season
climate_data <- climate_data %>%
  mutate(Season = case_when(
    Month %in% c(3,4,5) ~ "MAM (Long Rains)",
    Month %in% c(10,11,12) ~ "OND (Short Rains)",
    Month %in% c(1,2) ~ "JF (Dry Season)",
    Month %in% c(6,7,8,9) ~ "JJAS (Dry/Cool Season)",
    TRUE ~ "Other"
  ))

# Load GeoJSON
counties_geo <- st_read("data/kenyan-counties.geojson")

# Standardize name in GeoJSON to match CSV
counties_geo <- counties_geo %>% mutate(County_lower = tolower(COUNTY))

# --- UI ---
ui <- dashboardPage(
  dashboardHeader(title = "WeatherInformant - Kenyan Climate Dashboard", titleWidth = 450),
  dashboardSidebar(
    width = 250,
    sidebarMenu(
      menuItem("Overview", tabName = "overview", icon = icon("dashboard")),
      menuItem("Temperature Analysis", tabName = "temp", icon = icon("thermometer-half")),
      menuItem("Rainfall Patterns", tabName = "rain", icon = icon("cloud-rain")),
      menuItem("County Comparison", tabName = "compare", icon = icon("chart-bar")),
      menuItem("Seasonal Analysis", tabName = "seasonal", icon = icon("calendar")),
      menuItem("Data Explorer", tabName = "data", icon = icon("table"))
    ),
    hr(),
    selectInput("county_filter", "Select County:", 
                choices = c("All", sort(unique(climate_data$County_Name))),
                selected = "All", multiple = TRUE),
    sliderInput("year_filter", "Select Year Range:",
                min = min(climate_data$Year),
                max = max(climate_data$Year),
                value = c(1990,2018),
                step = 1,
                sep="")
  ),
  dashboardBody(
    tags$head(tags$style(HTML("
      .content-wrapper, .right-side {background-color: #f4f4f4;}
      .small-box {border-radius: 10px;}
      .skin-blue .main-header .logo {background-color: #3c8dbc;}
      .skin-blue .main-header .navbar {background-color: #3c8dbc;}
    "))),
    tabItems(
      # --- Overview Tab ---
      tabItem(tabName = "overview",
              fluidRow(
                box(title="About the App", status="info", solidHeader = TRUE, width=12,
                    "WeatherInformant is a Kenyan climate dashboard providing temperature and rainfall trends by county. ",
                    "Data sourced from the Meteorological Department of Kenya (1990-2018).")
              ),
              fluidRow(
                valueBoxOutput("total_counties"),
                valueBoxOutput("avg_temp"),
                valueBoxOutput("total_rainfall")
              ),
              fluidRow(
                box(title="Overall Climate Highlights", status="primary", solidHeader = TRUE, width=12,
                    DTOutput("overview_table"))
              ),
              fluidRow(
                box(title="Kenya Climate Map", status="primary", solidHeader=TRUE, width=12,
                    leafletOutput("climate_map", height=500))
              )
      ),
      # --- Temperature Tab ---
      tabItem(tabName="temp",
              fluidRow(
                box(title="Temperature Trends Over Time", status="danger", solidHeader=TRUE, width=12,
                    plotlyOutput("temp_trend", height=400))
              ),
              fluidRow(
                box(title="Monthly Temperature Patterns", status="warning", solidHeader=TRUE, width=6,
                    plotlyOutput("monthly_temp", height=350)),
                box(title="Temperature Distribution", status="info", solidHeader=TRUE, width=6,
                    plotlyOutput("temp_dist", height=350))
              )
      ),
      # --- Rainfall Tab ---
      tabItem(tabName="rain",
              fluidRow(
                box(title="Annual Rainfall Patterns", status="primary", solidHeader=TRUE, width=12,
                    plotlyOutput("rainfall_trend", height=400))
              ),
              fluidRow(
                box(title="Seasonal Rainfall Distribution", status="success", solidHeader=TRUE, width=6,
                    plotlyOutput("seasonal_rain", height=350)),
                box(title="Rainfall Anomaly", status="info", solidHeader=TRUE, width=6,
                    plotlyOutput("rainfall_anomaly", height=350))
              )
      ),
      # --- County Comparison ---
      tabItem(tabName="compare",
              fluidRow(
                box(title="County Temperature Comparison", status="warning", solidHeader=TRUE, width=12,
                    plotlyOutput("county_temp_comp", height=500))
              ),
              fluidRow(
                box(title="Top 10 Wettest Counties", status="success", solidHeader=TRUE, width=6,
                    plotlyOutput("top_wettest", height=350)),
                box(title="Top 10 Driest Counties", status="danger", solidHeader=TRUE, width=6,
                    plotlyOutput("top_driest", height=350))
              )
      ),
      # --- Seasonal Tab ---
      tabItem(tabName="seasonal",
              fluidRow(
                box(title="Seasonal Temperature Patterns by County", status="info", solidHeader=TRUE, width=12,
                    plotlyOutput("seasonal_temp", height=400))
              ),
              fluidRow(
                box(title="Seasonal Rainfall Heatmap", status="success", solidHeader=TRUE, width=12,
                    plotlyOutput("seasonal_heatmap", height=500))
              )
      ),
      # --- Data Explorer ---
      tabItem(tabName="data",
              fluidRow(
                box(title="Raw Climate Data", status="primary", solidHeader=TRUE, width=12,
                    DTOutput("raw_data_table"))
              )
      )
    )
  )
)

# --- Server ---
server <- function(input, output, session){
  
  # --- Filtered Data ---
  filtered_data <- reactive({
    data <- climate_data
    if(!"All" %in% input$county_filter && length(input$county_filter)>0){
      data <- data %>% filter(County_Name %in% input$county_filter)
    }
    data <- data %>% filter(Year >= input$year_filter[1], Year <= input$year_filter[2])
    return(data)
  })
  
  # --- Value Boxes ---
  output$total_counties <- renderValueBox({
    valueBox(length(unique(filtered_data()$County_Name)),"Counties Analyzed",icon=icon("map-marker-alt"),color="blue")
  })
  output$avg_temp <- renderValueBox({
    valueBox(round(mean(filtered_data()$tmean, na.rm=TRUE),1),"Average Temp (°C)",icon=icon("thermometer-half"),color="red")
  })
  output$total_rainfall <- renderValueBox({
    valueBox(paste0(round(sum(filtered_data()$rainfall, na.rm=TRUE),0)," mm"),"Total Rainfall",icon=icon("cloud-rain"),color="green")
  })
  
  # --- Overview Table ---
  output$overview_table <- renderDT({
    df <- filtered_data() %>%
      group_by(Year) %>%
      summarise(
        Avg_Temp = round(mean(tmean, na.rm=TRUE),1),
        Max_Temp = round(max(tmax, na.rm=TRUE),1),
        Min_Temp = round(min(tmin, na.rm=TRUE),1),
        Total_Rainfall = round(sum(rainfall, na.rm=TRUE),1),
        .groups="drop"
      )
    datatable(df, options=list(pageLength=15, scrollX=TRUE), rownames=FALSE)
  })
  
  # --- Climate Map ---
  output$climate_map <- renderLeaflet({
    county_avg <- filtered_data() %>%
      group_by(County_Name) %>%
      summarise(
        avg_temp = mean(tmean, na.rm=TRUE),
        max_temp = max(tmax, na.rm=TRUE),
        min_temp = min(tmin, na.rm=TRUE),
        total_rain = sum(rainfall, na.rm=TRUE),
        .groups="drop"
      )
    map_data <- counties_geo %>% left_join(county_avg, by=c("County_lower"="County_Name"))
    
    pal <- colorNumeric("YlOrRd", domain=map_data$avg_temp, na.color="#808080")
    
    leaflet(map_data) %>% addTiles() %>%
      setView(lng=37.5, lat=0.5, zoom=6) %>%
      addPolygons(
        fillColor = ~pal(avg_temp),
        weight=2, opacity=1, color="white", dashArray="3",
        fillOpacity=0.7,
        highlight=highlightOptions(weight=5,color="#666",dashArray="",fillOpacity=0.7,bringToFront=TRUE),
        label = ~paste0(COUNTY, ": Avg=",round(avg_temp,1),
                        "°C, Max=",round(max_temp,1),
                        "°C, Min=",round(min_temp,1),
                        "°C, Rain=",round(total_rain,1)," mm"),
        labelOptions = labelOptions(style=list("font-weight"="normal",padding="3px 8px"),
                                    textsize="15px",direction="auto")
      ) %>%
      addLegend(pal=pal, values=~avg_temp, opacity=0.7, title="Avg Temp (°C)", position="bottomright")
  })
  
  # --- Temperature Trend ---
  output$temp_trend <- renderPlotly({
    df <- filtered_data() %>% group_by(Year) %>% summarise(avg_temp=mean(tmean,na.rm=TRUE))
    plot_ly(df, x=~Year, y=~avg_temp, type='scatter', mode='lines+markers', line=list(color='firebrick')) %>%
      layout(title='Average Temperature Trend', yaxis=list(title='Temperature (°C)'))
  })
  
  # --- Monthly Temp ---
  output$monthly_temp <- renderPlotly({
    df <- filtered_data() %>% group_by(Month) %>% summarise(avg_temp=mean(tmean,na.rm=TRUE))
    plot_ly(df, x=~Month, y=~avg_temp, type='scatter', mode='lines+markers', line=list(color='red')) %>%
      layout(title='Average Monthly Temperature', xaxis=list(title='Month', tickvals=1:12, ticktext=month.abb),
             yaxis=list(title='Temperature (°C)'))
  })
  
  # --- Temp Distribution ---
  output$temp_dist <- renderPlotly({
    plot_ly(filtered_data(), y=~tmean, type='box', name='Average', boxpoints='all', jitter=0.3, pointpos=-1.8, marker=list(color='red')) %>%
      add_trace(y=~tmax,name='Max',marker=list(color='orange')) %>%
      add_trace(y=~tmin,name='Min',marker=list(color='blue')) %>%
      layout(title='Temperature Distribution', yaxis=list(title='Temperature (°C)'))
  })
  
  # --- Rainfall Trend ---
  output$rainfall_trend <- renderPlotly({
    df <- filtered_data() %>% group_by(Year) %>% summarise(total_rain=sum(rainfall,na.rm=TRUE))
    plot_ly(df, x=~Year, y=~total_rain, type='bar', marker=list(color='blue')) %>%
      layout(title='Annual Rainfall', yaxis=list(title='Rainfall (mm)'))
  })
  
  # --- Seasonal Rain ---
  output$seasonal_rain <- renderPlotly({
    df <- filtered_data() %>% group_by(Season) %>% summarise(avg_rain=mean(rainfall,na.rm=TRUE))
    plot_ly(df, x=~Season, y=~avg_rain, type='bar', marker=list(color='green')) %>%
      layout(title='Average Rainfall by Season', yaxis=list(title='Rainfall (mm)'))
  })
  
  # --- Rainfall Anomaly ---
  output$rainfall_anomaly <- renderPlotly({
    df <- filtered_data() %>% group_by(Year) %>% summarise(total_rain=sum(rainfall,na.rm=TRUE))
    df <- df %>% mutate(mean_rain=mean(total_rain), anomaly=total_rain-mean_rain)
    plot_ly(df, x=~Year, y=~anomaly, type='bar', marker=list(color=~ifelse(anomaly>0,'green','red'))) %>%
      layout(title='Rainfall Anomaly', yaxis=list(title='Deviation (mm)'))
  })
  
  # --- County Temp Comparison ---
  output$county_temp_comp <- renderPlotly({
    df <- filtered_data() %>% group_by(County_Name) %>% summarise(avg_temp=mean(tmean,na.rm=TRUE))
    plot_ly(df, x=~reorder(County_Name, avg_temp), y=~avg_temp, type='bar', marker=list(color='orange')) %>%
      layout(title='Average Temperature by County', xaxis=list(tickangle=-45), yaxis=list(title='Temp (°C)'))
  })
  
  # --- Top Wet/Dry Counties ---
  output$top_wettest <- renderPlotly({
    df <- filtered_data() %>% group_by(County_Name) %>% summarise(total_rain=sum(rainfall,na.rm=TRUE)) %>% arrange(desc(total_rain)) %>% head(10)
    plot_ly(df, x=~total_rain, y=~reorder(County_Name,total_rain), type='bar', orientation='h', marker=list(color='green')) %>%
      layout(title='Top 10 Wettest Counties', xaxis=list(title='Rainfall (mm)'))
  })
  
  output$top_driest <- renderPlotly({
    df <- filtered_data() %>% group_by(County_Name) %>% summarise(total_rain=sum(rainfall,na.rm=TRUE)) %>% arrange(total_rain) %>% head(10)
    plot_ly(df, x=~total_rain, y=~reorder(County_Name,total_rain), type='bar', orientation='h', marker=list(color='red')) %>%
      layout(title='Top 10 Driest Counties', xaxis=list(title='Rainfall (mm)'))
  })
  
  # --- Seasonal Temp ---
  output$seasonal_temp <- renderPlotly({
    df <- filtered_data() %>% group_by(County_Name,Season) %>% summarise(avg_temp=mean(tmean,na.rm=TRUE))
    plot_ly(df, x=~County_Name, y=~avg_temp, color=~Season, type='bar') %>%
      layout(title='Seasonal Temperature Patterns', barmode='group', xaxis=list(tickangle=45), yaxis=list(title='Temp (°C)'))
  })
  
  # --- Seasonal Rain Heatmap ---
  output$seasonal_heatmap <- renderPlotly({
    df <- filtered_data() %>% group_by(County_Name,Season) %>% summarise(avg_rain=mean(rainfall,na.rm=TRUE)) %>%
      pivot_wider(names_from=Season, values_from=avg_rain, values_fill=0)
    season_cols <- names(df)[-1]
    plot_ly(x=season_cols, y=df$County_Name, z=as.matrix(df[,season_cols]), type='heatmap', colorscale='Blues') %>%
      layout(title='Seasonal Rainfall Heatmap', xaxis=list(title='Season'), yaxis=list(title='County'))
  })
  
  # --- Raw Data Table ---
  output$raw_data_table <- renderDT({
    df <- filtered_data() %>% select(Date, County_Name, tmean, tmax, tmin, rainfall, Season)
    datatable(df, options=list(pageLength=25, scrollX=TRUE, scrollY="500px"), rownames=FALSE)
  })
}

# --- Run App ---
shinyApp(ui, server)
