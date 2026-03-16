# Data Sources Documentation

## Zillow ZORI (Zillow Observed Rent Index)
The Zillow Observed Rent Index (ZORI) provides a measure of rent trends across various markets and geographic areas in the United States. It aggregates rental data from millions of listings to offer a comprehensive perspective on rent prices.

### Key Features:
- Real-time rental price trends
- Detailed breakdown by geographic region and property type

## HUD PIT (Point-In-Time) Data
The HUD Point-In-Time (PIT) count offers a snapshot of homelessness in the United States, typically conducted on a single night in January. The data is used by the Department of Housing and Urban Development (HUD) to understand the scale and scope of homelessness across various demographics.

### Key Features:
- Annual count of homeless individuals
- Demographic breakdown (e.g., by age, gender, family status)

## File Structure
The following is the general structure of the data files in the repository:
- `zillow_data/`
  - Contains ZORI files with rent trends data
- `hud_pit_data/`
  - Contains HUD PIT count files with demographic data

## Data Processing Notes
- Data is usually collected on a quarterly basis for ZORI and annually for HUD PIT.
- All raw data must be cleaned and standardized before analysis. This includes null value handling, data type conversion, and removal of duplicates.