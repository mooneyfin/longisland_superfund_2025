library(spatstat)
library(sf)

# Specify the path to your shapefile
shapefile_path <- "C:/Users/moone/OneDrive - Columbia University Irving Medical Center/MiscResearch/Superfund/Data/State_Superfund/State_Superfund.shp"

# Read in the shapefile
sites <- st_read(shapefile_path)
sites_crs <- st_crs(sites)

# Convert polygons to centroids
centroids <- st_centroid(sites)
head(centroids)

# Plot the centroids
plot(st_geometry(centroids), main = "Centroids of Polygons")

LI <- st_read("C:/Users/moone/OneDrive - Columbia University Irving Medical Center/MiscResearch/Superfund/Data/Tract_Boundary.shp")
st_crs(LI)
LI <- st_transform(LI, crs = sites_crs)


LIOwin <- as.owin(LI)
class(LIOwin)
LIOwin

pts <- st_coordinates(centroids)
head(pts)

p <- ppp(pts[,1], pts[,2], window=LIOwin)
class(p)
p
plot(p)

# calculate and plot Ripley's K function using the 'Ripley' correction
kf <- Kest(p, correction = "Ripley")
plot(kf)

# calculate envelope around L-hat estimates.
lf.env <- envelope(p, Lest, correction = "Ripley", verbose = F)

# Plot with custom x-axis label and title
plot(lf.env, main = "",xlab = "Distance (m)")





# Specify the path to your shapefile
shapefile_path <- "C:/Users/moone/OneDrive - Columbia University Irving Medical Center/MiscResearch/Superfund/Data/Federal_Superfund/Federal_Superfund.shp"

# Read in the shapefile
sites <- st_read(shapefile_path)
sites_crs <- st_crs(sites)

# Convert polygons to centroids
centroids <- st_centroid(sites)
head(centroids)

# Plot the centroids
plot(st_geometry(centroids), main = "Centroids of Polygons")

LI <- st_read("C:/Users/moone/OneDrive - Columbia University Irving Medical Center/MiscResearch/Superfund/Data/Tract_Boundary.shp")
st_crs(LI)
LI <- st_transform(LI, crs = sites_crs)


LIOwin <- as.owin(LI)
class(LIOwin)
LIOwin

pts <- st_coordinates(centroids)
head(pts)

p <- ppp(pts[,1], pts[,2], window=LIOwin)
class(p)
p
plot(p)

# calculate and plot Ripley's K function using the 'Ripley' correction
kf <- Kest(p, correction = "Ripley")
plot(kf)

# calculate envelope around L-hat estimates.
lf.env <- envelope(p, Lest, correction = "Ripley", verbose = F)
# Plot with title
plot(lf.env, main = "",xlab = "Distance (m)")