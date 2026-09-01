library(EVR628tools)
library(tidyverse)
data(data_lionfish)

p <- ggplot(data_lionfish,
            aes(x = total_length_mm, y = total_weight_gr)) +
  geom_point()
p
ggsave(plot = p, filename = "results/img/first_plot.png")


#additional practice
summary(cars)
view(cars)

cars_plot<-ggplot(cars,aes(x=speed, y=dist))+
  geom_point()
cars_plot
