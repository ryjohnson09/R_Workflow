library(plumber)
library(pins)

# Connect to Posit Connect
board <- pins::board_rsconnect(server = "https://colorado.posit.co/rsc",
                               key = Sys.getenv("CONNECT_API_KEY"))

#* @apiTitle Geyser Plot API

#* @apiDescription Return vector of bin breaks
#* @param n_bins Number of bins
#* @get /breaks

function(n_bins){
  
  # Pinned Data
  x <- pins::pin_read(board, "ryan/Faithful_Geyser_Data")
  
  # Calculate bin breaks
  seq(min(x), max(x), length.out = as.numeric(n_bins) + 1)
  
}