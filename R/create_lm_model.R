library(dplyr)
library(caret)
library(pins)
library(vetiver)

# Data
cars <- mtcars

# Train simple lm model with Caret 
lm_model <- caret::train(mpg ~ hp + wt + gear + disp, 
                  data = cars, 
                  method = "lm")

summary(lm_model)

# Create the Vetiver model object
v_model <- vetiver::vetiver_model(lm_model, "lm_cars")

# Connect to a pin board on Connect
board <- board_connect(auth = "envvar")

# Pin the model (uploads it to Connect)
vetiver::vetiver_pin_write(board,
                  v_model,
                  "lm_cars_vmodel")

# Deploy the pinned model to Connect as an API
vetiver_deploy_rsconnect(
  board = board, 
  name = "randre/lm_cars",
  predict_args = list(debug = TRUE),
  account = "randre"
)

# Can now access endpoint via Vetiver endpoint functions,
# or from normal Post commands

