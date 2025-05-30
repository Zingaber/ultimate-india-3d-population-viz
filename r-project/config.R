# ============================================================================
# ULTIMATE INDIA 3D VISUALIZATION - CONFIGURATION
# Modify these settings for your setup
# ============================================================================

# 📁 DIRECTORY CONFIGURATION
PROJECT_ROOT <- "C:/Users/josze/MyGithub/ultimate-india-3d-population-viz"
DATA_DIR <- file.path(PROJECT_ROOT, "r-project", "data")
OUTPUT_DIR <- file.path(PROJECT_ROOT, "r-project", "output")
GALLERY_DIR <- file.path(PROJECT_ROOT, "gallery", "static")

# Create directories if they don't exist
if (!dir.exists(DATA_DIR)) dir.create(DATA_DIR, recursive = TRUE)
if (!dir.exists(OUTPUT_DIR)) dir.create(OUTPUT_DIR, recursive = TRUE)
if (!dir.exists(GALLERY_DIR)) dir.create(GALLERY_DIR, recursive = TRUE)

# 📊 DATA CONFIGURATION
# Update this path to your population data file
POPULATION_DATA_PATH <- file.path(DATA_DIR, "india_population_data.csv")

# Expected column names (the script will auto-detect X,Y,Z or x,y,z)
EXPECTED_COLUMNS <- c("x", "y", "z")  # or c("X", "Y", "Z")

# 🎨 VISUALIZATION SETTINGS
MAP_RESOLUTION <- 4000        # Matrix resolution (higher = more detail)
EXPORT_WIDTH <- 3000          # Export image width
EXPORT_HEIGHT <- 2250         # Export image height
RENDER_QUALITY <- "high"      # "standard", "high", "ultra"

# 🗺️ GEOGRAPHIC SETTINGS
INDIA_CENTER_LAT <- 23.0      # India center latitude
INDIA_CENTER_LNG <- 78.0      # India center longitude
INDIA_CRS <- "+proj=laea +lat_0=20 +lon_0=78 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"

# 🎨 COLOR PALETTES
PALETTE_NAMES <- c(
  "population_spectrum",
  "tricolor_gradient", 
  "sunset_india",
  "terrain_pop",
  "mono_elegant",
  "vibrant_contrast"
)

# 📸 EXPORT SETTINGS
EXPORT_FORMATS <- c("png")     # Export formats
CREATE_WEB_GALLERY <- TRUE     # Create HTML gallery
CREATE_COMPARISONS <- TRUE     # Create comparison images

# 🔧 PROCESSING SETTINGS
SMOOTHING_METHOD <- "hybrid"       # "simple", "gaussian", "adaptive", "hybrid"
SCALING_METHOD <- "cube_root_log"  # "cube_root", "fourth_root", "log_plus", "cube_root_log"
ENABLE_ELEVATION <- TRUE           # Add elevation context
MAX_PROCESSING_TIME <- 30          # Maximum processing time in minutes

# 📊 PERFORMANCE SETTINGS
PARALLEL_PROCESSING <- TRUE        # Use multiple CPU cores
MAX_MEMORY_GB <- 8                 # Maximum memory usage
CACHE_INTERMEDIATE <- TRUE         # Cache intermediate results

# Print configuration
cat("🔧 Configuration loaded:\n")
cat("- Data directory:", DATA_DIR, "\n")
cat("- Output directory:", OUTPUT_DIR, "\n")
cat("- Export resolution:", EXPORT_WIDTH, "x", EXPORT_HEIGHT, "\n")
cat("- Quality setting:", RENDER_QUALITY, "\n")
cat("- Smoothing method:", SMOOTHING_METHOD, "\n")