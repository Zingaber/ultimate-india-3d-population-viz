// Ultimate India 3D Cartographic Population Visualization
console.log('🇮🇳 Starting India 3D Cartographic Visualization...');

// Global variables
let scene, camera, renderer, controls;
let indiaMap, stateGeometries = [];
let populationData, geoData;
let raycaster, mouse;

// Initialize the application when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    initVisualization();
});

async function initVisualization() {
    console.log('🎬 Initializing 3D cartographic visualization...');
    
    // Set up the 3D scene
    setupScene();
    
    // Load India GeoJSON data and create 3D map
    await loadIndiaGeoData();
    
    // Set up controls and interactions
    setupControls();
    setupInteractions();
    
    // Start the render loop
    animate();
    
    // Update controls panel
    updateControlsPanel();
}

function setupScene() {
    // Create scene
    scene = new THREE.Scene();
    scene.background = new THREE.Color(0x0a0a1a);
    
    // Create camera
    const container = document.getElementById('visualization-container');
    camera = new THREE.PerspectiveCamera(
        60, 
        container.clientWidth / container.clientHeight, 
        0.1, 
        1000
    );
    camera.position.set(0, 25, 40);
    
    // Create renderer
    renderer = new THREE.WebGLRenderer({ 
        antialias: true,
        alpha: true 
    });
    renderer.setSize(container.clientWidth, container.clientHeight);
    renderer.shadowMap.enabled = true;
    renderer.shadowMap.type = THREE.PCFSoftShadowMap;
    renderer.setClearColor(0x0a0a1a, 1);
    container.appendChild(renderer.domElement);
    
    // Add lights for better 3D visualization
    const ambientLight = new THREE.AmbientLight(0x404040, 0.6);
    scene.add(ambientLight);
    
    const directionalLight = new THREE.DirectionalLight(0xffffff, 0.8);
    directionalLight.position.set(20, 30, 20);
    directionalLight.castShadow = true;
    directionalLight.shadow.mapSize.width = 2048;
    directionalLight.shadow.mapSize.height = 2048;
    scene.add(directionalLight);
    
    // Add point lights for dramatic effect
    const pointLight1 = new THREE.PointLight(0x4ecdc4, 0.5, 100);
    pointLight1.position.set(10, 15, 10);
    scene.add(pointLight1);
    
    const pointLight2 = new THREE.PointLight(0xff6b6b, 0.3, 100);
    pointLight2.position.set(-10, 15, -10);
    scene.add(pointLight2);
    
    // Setup raycaster for mouse interactions
    raycaster = new THREE.Raycaster();
    mouse = new THREE.Vector2();
    
    // Handle window resize
    window.addEventListener('resize', onWindowResize);
}

// Enhanced local India GeoJSON with more realistic state boundaries
function createEnhancedIndiaGeoJSON() {
    return {
        "type": "FeatureCollection",
        "features": [
            // Maharashtra - more realistic shape
            {
                "type": "Feature",
                "properties": { "name": "Maharashtra", "population": 112374333, "capital": "Mumbai" },
                "geometry": {
                    "type": "Polygon",
                    "coordinates": [[
                        [72.6, 21.0], [76.8, 21.2], [78.2, 19.8], [77.5, 17.5], 
                        [75.8, 15.8], [73.5, 15.6], [72.8, 16.8], [72.6, 21.0]
                    ]]
                }
            },
            // Uttar Pradesh - northern state
            {
                "type": "Feature", 
                "properties": { "name": "Uttar Pradesh", "population": 199812341, "capital": "Lucknow" },
                "geometry": {
                    "type": "Polygon",
                    "coordinates": [[
                        [77.0, 30.3], [84.6, 30.1], [84.4, 23.8], [82.2, 23.6],
                        [80.8, 24.2], [78.5, 24.1], [77.2, 26.8], [77.0, 30.3]
                    ]]
                }
            },
            // West Bengal - eastern state with distinctive shape
            {
                "type": "Feature",
                "properties": { "name": "West Bengal", "population": 91276115, "capital": "Kolkata" },
                "geometry": {
                    "type": "Polygon", 
                    "coordinates": [[
                        [85.8, 27.2], [89.8, 26.8], [89.6, 25.2], [88.8, 22.0],
                        [87.2, 21.6], [85.2, 22.8], [85.4, 25.2], [85.8, 27.2]
                    ]]
                }
            },
            // Tamil Nadu - southern state
            {
                "type": "Feature",
                "properties": { "name": "Tamil Nadu", "population": 72147030, "capital": "Chennai" },
                "geometry": {
                    "type": "Polygon",
                    "coordinates": [[
                        [76.2, 13.2], [80.3, 13.4], [80.1, 10.4], [78.8, 8.2],
                        [77.2, 8.0], [76.5, 9.8], [76.0, 11.6], [76.2, 13.2]
                    ]]
                }
            },
            // Karnataka - southwestern state
            {
                "type": "Feature",
                "properties": { "name": "Karnataka", "population": 61095297, "capital": "Bangalore" },
                "geometry": {
                    "type": "Polygon",
                    "coordinates": [[
                        [74.2, 18.4], [78.8, 18.2], [78.6, 14.8], [77.6, 12.0],
                        [75.8, 11.6], [74.0, 12.8], [73.8, 15.6], [74.2, 18.4]
                    ]]
                }
            },
            // Gujarat - western state
            {
                "type": "Feature",
                "properties": { "name": "Gujarat", "population": 60439692, "capital": "Gandhinagar" },
                "geometry": {
                    "type": "Polygon",
                    "coordinates": [[
                        [68.2, 24.6], [74.8, 24.8], [74.6, 20.2], [72.8, 19.6],
                        [70.2, 20.4], [68.8, 22.8], [68.2, 24.6]
                    ]]
                }
            },
            // Rajasthan - large northwestern state
            {
                "type": "Feature",
                "properties": { "name": "Rajasthan", "population": 68548437, "capital": "Jaipur" },
                "geometry": {
                    "type": "Polygon",
                    "coordinates": [[
                        [69.2, 30.2], [78.2, 30.0], [78.0, 26.2], [76.2, 24.2],
                        [72.8, 23.8], [70.2, 24.8], [69.0, 27.8], [69.2, 30.2]
                    ]]
                }
            },
            // Andhra Pradesh - southeastern state  
            {
                "type": "Feature",
                "properties": { "name": "Andhra Pradesh", "population": 49386799, "capital": "Amaravati" },
                "geometry": {
                    "type": "Polygon",
                    "coordinates": [[
                        [76.8, 19.2], [84.8, 19.0], [84.6, 16.2], [80.2, 13.6],
                        [78.2, 13.4], [77.2, 15.8], [76.8, 19.2]
                    ]]
                }
            },
            // Madhya Pradesh - central state
            {
                "type": "Feature",
                "properties": { "name": "Madhya Pradesh", "population": 72626809, "capital": "Bhopal" },
                "geometry": {
                    "type": "Polygon",
                    "coordinates": [[
                        [74.8, 26.8], [82.8, 26.6], [82.6, 21.6], [78.8, 21.4],
                        [76.2, 21.8], [74.6, 23.8], [74.8, 26.8]
                    ]]
                }
            },
            // Kerala - southwestern coastal state
            {
                "type": "Feature", 
                "properties": { "name": "Kerala", "population": 33406061, "capital": "Thiruvananthapuram" },
                "geometry": {
                    "type": "Polygon",
                    "coordinates": [[
                        [74.8, 12.8], [77.2, 12.6], [77.0, 8.2], [76.2, 8.0],
                        [75.8, 10.6], [74.8, 12.8]
                    ]]
                }
            }
        ]
    };
}

// Function to load real India GeoJSON data from external source
async function loadRealIndiaData() {
    try {
        updateControlsPanel('🔄 Loading real India map data...');
        
        // Option 1: Try to load from a public GeoJSON source
        let indiaData;
        
        try {
            // Attempt to load from Natural Earth or similar public source
            const response = await fetch('https://raw.githubusercontent.com/holtzy/D3-graph-gallery/master/DATA/world.geojson');
            const worldData = await response.json();
            
            // Filter for India
            indiaData = {
                type: "FeatureCollection",
                features: worldData.features.filter(feature => 
                    feature.properties.NAME === "India" || 
                    feature.properties.name === "India" ||
                    feature.properties.NAME_EN === "India"
                )
            };
            
            if (indiaData.features.length === 0) {
                throw new Error("India not found in world data");
            }
            
        } catch (fetchError) {
            console.log("External data not available, using enhanced local data");
            // Enhanced local India data with more realistic boundaries
            indiaData = createEnhancedIndiaGeoJSON();
        }
        
        return indiaData;
        
    } catch (error) {
        console.error('Error loading India data:', error);
        updateControlsPanel('⚠️ Using fallback map data');
        return createEnhancedIndiaGeoJSON();
    }
}

async function loadIndiaGeoData() {
    try {
        updateControlsPanel('🔄 Loading India map data...');
        
        // Try to load real data first, fallback to enhanced local data
        const indiaGeoJSON = await loadRealIndiaData();
        
        await createIndiaMap(indiaGeoJSON);
        updateControlsPanel('✅ India cartographic map loaded successfully!');