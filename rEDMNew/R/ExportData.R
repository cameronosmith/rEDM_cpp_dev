#file to export the csv's by reading them in here

if ( TRUE ) {
    block_3sp           <- read.csv("../data/block_3sp.csv")
    TentMap             <- read.csv("../data/TentMap_rEDM.csv")
    TentMapNoise        <- read.csv("../data/TentMapNoise_rEDM.csv")
    circle              <- read.csv("../data/circle.csv")
    sardine_anchovy_sst <- read.csv("../data/sardine_anchovy_sst.csv")
} else {
    block_3sp           <- read.csv("data/block_3sp.csv")
    TentMap             <- read.csv("data/TentMap_rEDM.csv")
    TentMapNoise        <- read.csv("data/TentMapNoise_rEDM.csv")
    circle              <- read.csv("data/circle.csv")
    sardine_anchovy_sst <- read.csv("data/sardine_anchovy_sst.csv")
}
