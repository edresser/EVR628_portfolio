library(EVR628tools)
library(tidyverse)
data(data_lionfish)

p <- ggplot(data_lionfish,
            aes(x = total_length_mm, y = total_weight_gr)) +
  geom_point()
p
ggsave(plot = p, filename = "results/img/first_plot.png")
