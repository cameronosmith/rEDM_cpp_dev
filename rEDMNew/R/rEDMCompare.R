library(rEDM)
df <- read.csv("tmp.csv")
#print(s_map(df,E=1:4,theta=1:2,tp=1:3))
print(simplex(df,E=1))
