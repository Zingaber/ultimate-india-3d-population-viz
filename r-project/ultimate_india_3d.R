# ============================================================================
# ULTIMATE INDIA 3D POPULATION VISUALIZATION - MAIN SCRIPT
# Creates professional static 3D renders for GitHub showcase
# ============================================================================

# Load configuration
source("r-project/config.R")

# Load required libraries
suppressPackageStartupMessages({
  library(tidyverse)
  library(rayshader)
  library(scales)
})

# ============================================================================
# SIMPLIFIED FUNCTIONS FOR QUICK START
# ============================================================================

create_sample_data <- function() {
  cat("📊 Creating sample India population data...\n")
  
  # Create sample cities with realistic coordinates
  sample_cities <- data.frame(
    x = c(72.8777, 77.1025, 77.5946, 80.2707, 88.3639, 78.4867, 73.8567, 72.5714),
    y = c(19.0760, 28.7041, 12.9716, 13.0827, 22.5726, 17.3850, 18.5204, 23.0225),
    z = c(20411000, 31181000, 12765000, 10971000, 14850000, 9746000, 6629000, 7650000)
  )
  
  # Expand to create a grid around each city
  sample_data <- data.frame()
  
  for (i in 1:nrow(sample_cities)) {
    city <- sample_cities[i, ]
    
    # Create a grid around each city
    x_range <- seq(city$x - 1, city$x + 1, by = 0.1)
    y_range <- seq(city$y - 1, city$y + 1, by = 0.1)
    
    city_grid <- expand.grid(x = x_range, y = y_range)
    
    # Add population with distance decay
    city_grid$z <- city$z * exp(-((city_grid$x - city$x)^2 + (city_grid$y - city$y)^2) * 5)
    
    sample_data <- rbind(sample_data, city_grid)
  }
  
  # Save sample data
  write.csv(sample_data, POPULATION_DATA_PATH, row.names = FALSE)
  cat("✅ Sample data created with", nrow(sample_data), "points\n")
  
  return(sample_data)
}

load_population_data <- function() {
  if (!file.exists(POPULATION_DATA_PATH)) {
    cat("⚠️ No population data found. Creating sample data...\n")
    return(create_sample_data())
  }
  
  cat("📊 Loading population data from:", basename(POPULATION_DATA_PATH), "\n")
  
  # Read data
  data <- read.csv(POPULATION_DATA_PATH)
  
  # Check column names
  if (all(c("X", "Y", "Z") %in% names(data))) {
    names(data) <- c("x", "y", "z")
  }
  
  # Clean data
  data <- data %>%
    filter(!is.na(x), !is.na(y), !is.na(z), z > 0)
  
  cat("✅ Loaded", scales::comma(nrow(data)), "population points\n")
  return(data)
}

create_basic_3d_map <- function(data) {
  cat("🎨 Creating 3D visualization...\n")
  
  # Create raster from XYZ data
  library(raster)
  pop_raster <- rasterFromXYZ(data[, c("x", "y", "z")])
  
  # Convert to matrix
  pop_matrix <- raster_to_matrix(pop_raster)
  
  # Handle missing values
  pop_matrix[is.na(pop_matrix)] <- 0
  
  # Scale for visualization
  pop_scaled <- pop_matrix^(1/3)  # Cube root scaling
  pop_scaled <- (pop_scaled - min(pop_scaled, na.rm = TRUE)) / 
                (max(pop_scaled, na.rm = TRUE) - min(pop_scaled, na.rm = TRUE))
  pop_scaled <- pop_scaled * 20  # Scale height
  
  # Create color palette
  colors <- colorRampPalette(c("#2E7D32", "#4CAF50", "#8BC34A", "#CDDC39",
                              "#FFEB3B", "#FFC107", "#FF9800", "#FF5722"))(256)
  
  # Create hillshade
  hillshade <- height_shade(pop_scaled, texture = colors)
  
  # Close any existing 3D windows
  try(rgl::close3d(), silent = TRUE)
  
  # Create 3D plot
  plot_3d(
    hillshade,
    heightmap = pop_scaled,
    zscale = 0.05,
    solid = TRUE,
    shadow = TRUE,
    windowsize = c(1200, 900),
    phi = 30,
    theta = 45,
    zoom = 0.7,
    background = "#87CEEB",
    shadowcolor = "#2F4F4F"
  )
  
  # Save snapshot
  timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
  filename <- file.path(OUTPUT_DIR, paste0("india_3d_", timestamp, ".png"))
  
  render_snapshot(filename, width = 1600, height = 1200)
  
  cat("✅ 3D visualization saved:", basename(filename), "\n")
  return(filename)
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

cat("🗺️ ULTIMATE INDIA 3D POPULATION VISUALIZATION\n")
cat("==============================================\n\n")

# Check if R packages are available
required_packages <- c("tidyverse", "rayshader", "raster")
missing_packages <- required_packages[!sapply(required_packages, requireNamespace, quietly = TRUE)]

if (length(missing_packages) > 0) {
  cat("❌ Missing required packages:", paste(missing_packages, collapse = ", "), "\n")
  cat("🔧 Please run: source('r-project/setup_environment.R')\n")
  stop("Required packages not available")
}

# Step 1: Load data
data <- load_population_data()

# Step 2: Create visualization
result_file <- create_basic_3d_map(data)

# Step 3: Summary
cat("\n✅ VISUALIZATION COMPLETE!\n")
cat("📁 Output saved to:", result_file, "\n")
cat("📊 Data points processed:", scales::comma(nrow(data)), "\n")

# Create simple gallery index
gallery_html <- paste0(
  "<!DOCTYPE html><html><head><title>India 3D Visualization Gallery</title></head>",
  "<body style='font-family: Arial; background: #f0f0f0; padding: 20px;'>",
  "<h1>🗺️ Ultimate India 3D Population Visualization</h1>",
  "<p>Generated on: ", Sys.time(), "</p>",
  "<img src='../r-project/output/", basename(result_file), "' style='max-width: 100%; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.3);'>",
  "<p>Data points: ", scales::comma(nrow(data)), "</p>",
  "</body></html>"
)

gallery_path <- file.path(GALLERY_DIR, "index.html")
writeLines(gallery_html, gallery_path)

cat("🌐 Gallery created at:", gallery_path, "\n")
cat("\n🚀 Ready for GitHub upload!\n")