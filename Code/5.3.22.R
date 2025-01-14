library(rtweet)
library(tidytuesdayR)
library(tidyverse)
library(lubridate)
library(tidyquant)
library(hrbrthemes)
library(viridis)

tuesdata <- tt_load('2022-05-03')

capacity <- 
    tuesdata[1] %>% as.data.frame()
wind <- 
    tuesdata[2] %>% as.data.frame()
solar <- 
    tuesdata[3] %>% as.data.frame()
average_cost <- 
    tuesdata[4] %>% as.data.frame()


# monthly wind generation
wind_by_month <- 
    wind %>% 
    mutate(month = ymd(wind.date) %>% floor_date("month") %>% month(label = T),
           year  = ymd(wind.date) %>% year()) %>% 
    group_by(year, month) %>% 
    summarize(avg_mwh        = mean(wind.wind_mwh),
              total_capacity = sum(wind.wind_capacity)) %>% 
    ungroup()


# monthly solar generation
solar_by_month <- 
    solar %>% 
    mutate(month = ymd(solar.date) %>% floor_date("month") %>% month(label = T),
           year  = ymd(solar.date) %>% year()) %>% 
    group_by(year, month) %>% 
    summarize(avg_mwh        = mean(solar.solar_mwh),
              total_capacity = sum(solar.solar_capacity)) %>% 
    ungroup()



wplot <- 
    wind_by_month %>% 
    ggplot(aes(month,avg_mwh, fill = as_factor(year), group = year))+
    geom_point()+
    geom_col()+
    coord_polar()+
    theme_tq()+
    theme(panel.grid = element_blank(), legend.position = "right")+
    labs(
        title = "Average Price of Wind Power",
        subtitle = "Monthly, 2009 - 2020",
        caption=
        "Source: Berkeley Lab's 'Utility-Scale Solar, 2021 Edition' \n
         #TidyTuesday
         Visualization by Noah Silver - @noahsilver12 ",
        x = NULL,
        y = "Average Price ($/MWh)",
        fill = "Year"
    )
    
ggsave("wplot.png", width = 7, height = 5)

splot <- 
    solar_by_month %>% 
    ggplot(aes(month,avg_mwh, fill = as_factor(year), group = year))+
    geom_point()+
    geom_col()+
    coord_polar()+
    theme_tq()+
    theme(panel.grid = element_blank(), legend.position = "right")+
    labs(
        title = "Average Price of Solar Power",
        subtitle = "Monthly, 2009 - 2021",
        caption=
            "Source: Berkeley Lab's 'Utility-Scale Solar, 2021 Edition' \n
         #TidyTuesday
         Visualization by Noah Silver - @noahsilver12 ",
        x = NULL,
        y = "Average Price ($/MWh)",
        fill = "Year"
    )


ggsave("splot.png", width = 7, height = 5)





post_tweet(
    status = "A few days late, but fitting first #TidyTuesday topic! Excited to share my take on this week's data from @BerkeleyLab.\nCode: https://github.com/noahsilver-are/TidyTuesday/blob/main/TTResponse/5.3.22.R",
    media = c("wplot.png","splot.png"))

