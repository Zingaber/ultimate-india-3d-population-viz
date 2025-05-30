# ============================================================================
# ULTIMATE INDIA 3D VISUALIZATION - R ENVIRONMENT SETUP
# Run this file once to install all required packages
# ============================================================================

cat("🔧 Setting up R environment for Ultimate India 3D Visualization...\n\n")

# List of required packages
required_packages <- c(
  # Core data manipulation
  "tidyverse",      # Data manipulation and visualization
  "dplyr",          # Data manipulation
  "readr",          # File reading
  
  # Spatial data handling
  "sf",             # Spatial features
  "stars",          # Spatiotemporal arrays
  "raster",         # Raster data operations
  "terra",          # Modern raster handling
  
  # 3D visualization and rendering
  "rayshader",      # 3D visualization engine
  "rayrender",      # Advanced 3D rendering
  "rgl",            # 3D graphics
  
  # Data sources and elevation
  "elevatr",        # Elevation data access
  "giscoR",         # Geographic boundaries
  
  # Image processing and export
  "magick",         # Image processing
  "scales",         # Scale formatting
  "viridis",        # Color palettes
  
  # Optional advanced packages
  "pracma",         # Advanced mathematical functions
  "httr",           # HTTP requests
  "jsonlite",       # JSON handling
  "R.utils"         # Utilities
)

# Function to install packages if not already installed
install_if_needed <- function(packages) {
  new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  
  if (length(new_packages) > 0) {
    cat("📦 Installing", length(new_packages), "packages:", paste(new_packages, collapse = ", "), "\n")
    install.packages(new_packages, dependencies = TRUE, repos = "https://cran.r-project.org/")
  } else {
    cat("✅ All required packages are already installed!\n")
  }
}

# Install packages
install_if_needed(required_packages)

# Load and test core packages
cat("\n🧪 Testing package installation...\n")

test_packages <- c("tidyverse", "sf", "rayshader", "raster")
success_count <- 0

for (pkg in test_packages) {
  result <- tryCatch({
    library(pkg, character.only = TRUE, quietly = TRUE)
    cat("✅", pkg, "loaded successfully\n")
    success_count <- success_count + 1
    TRUE
  }, error = function(e) {
    cat("❌", pkg, "failed to load:", e$message, "\n")
    FALSE
  })
}

# Final status
cat("\n📊 Installation Summary:\n")
cat("- Required packages:", length(required_packages), "\n")
cat("- Successfully tested:", success_count, "/", length(test_packages), "\n")

if (success_count == length(test_packages)) {
  cat("🎉 Environment setup complete! You're ready to create stunning 3D visualizations.\n")
} else {
  cat("⚠️ Some packages failed to load. Please check the error messages above.\n")
}

cat("\n🚀 Next steps:\n")
cat("1. Update data path in config.R\n")
cat("2. Place your population data in r-project/data/\n")
cat("3. Run ultimate_india_3d.R to create visualizations\n")