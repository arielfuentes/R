library(ff)
library(ETLUtils)
library(RPostgreSQL)
library(sp)
library(rgeos)
library(dplyr)
library(ggplot2)
library(ggmap)
library(spatstat)
library(maptools)
library(rgdal)

m <- dbDriver("PostgreSQL")
con <- dbConnect(m, host = "localhost", user= "postgres", password="admin", 
                 dbname = "bip")
dbListConnections(m)
dbGetInfo(con)
summary(con)
dbListTables(con)
#dbExistsTable(con, "etapas_2013")
Izone <- read.dbi.ffdf(
  query = "SELECT count(id), x_subida, y_subida, zona_subida, 
           ST_AsText(geom) AS wkt_geometry
            FROM etapas_2013
            where zona_subida = '772'
            group by zona_subida, id, x_subida, y_subida, geom", 
  dbConnect.args = list(con), VERBOSE=TRUE)
Izonedf <- as.data.frame(Izone)
Izonedf$ID <- 1:length(Izone_wkt)
dbDisconnect(con)
Izone_wkt <- as.character(Izonedf[, 5])

Izone_wkt2 <- data.frame(PointWKT = Izone_wkt, ID = Izonedf$ID)
point.sp <- SpatialPointsDataFrame(readWKT(Izone_wkt2$PointWKT[1]), 
                         data = data.frame(ID = Izonedf$ID[1], count = Izonedf$count[1], 
                                           zona_subida = Izonedf$zona_subida[1]))
ptm <- proc.time()
for(n in 2:length(Izone_wkt2$ID)){
  point.sp <- rbind(point.sp,
                    SpatialPointsDataFrame(readWKT(Izone_wkt2$PointWKT[n]),
                          data.frame(ID = Izonedf$ID[n], count = Izonedf$count[n], 
                                     zona_subida = Izonedf$zona_subida[n])))
}
ptm2 <- proc.time() - ptm
proj4string(obj = point.sp) <- CRS("+init=epsg:32719")
point.sp.bbox <- as.data.frame(box@coords)
point.sp@coords <- as.matrix(point.sp.bbox)
point.sp <- spTransform(point.sp, CRS("+proj=longlat +datum=WGS84"))
summary(point.sp)
plot(point.sp, axes = 1)
# p <- ggplot(point.sp@data, aes(count, zona_subida))
# p + geom_point()
point.sp2 <- cbind(point.sp@coords, point.sp@data)
map <- ggplot(point.sp2, aes(x, y)) +
  geom_point() +
  coord_equal() +
  labs(x = "Este (m)", y = "Norte (m)",
  fill = count) +
  ggtitle("Zona 772")
map
# ggsave("large_plot.png", scale = 3, dpi = 400)
# box <- point.sp
# a <- as.data.frame(box@coords[,1:2])
# rownames(a) <- NULL
# box@coords <- as.matrix(a)
# res <- spTransform(box, CRS("+proj=longlat +datum=WGS84"))
res2 <- bbox(point.sp)
res2[1, ] <- (res2[1, ] - mean(res2[1, ])) * 1.3 + mean(res2[1, ])
res2[2, ] <- (res2[2, ] - mean(res2[2, ])) * 1.3 + mean(res2[2, ])
point.sp.loc <- ggmap(get_map(location = res2), source = "stamen", maptype = "toner", crop = T)
point.sp.loc +
  geom_point(data = point.sp2, aes(x = x, y = y))
# scale longitude and latitude (increase bb by 5% for plot)
# point.pp <- as(point.sp, "ppp")
# K <- Kest(point.pp)
# plot(K)
# plot(density(point.pp, 100))
# contour(density(point.pp, 100))
# hist(point.pp$x)
