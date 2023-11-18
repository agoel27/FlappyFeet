# Models the spring (bounciness) for the water
# credit: Pixelipy 
extends Node2D

# Current velocity of spring
var currVelocity = 0;
# Force applied to spring
var springForce = 0;
# Current height of spring
var currHeight = 0
# Natural height of spring (height of spring with no force applied)
var targetHeight = 0

## Applies Hooke's Law to the spring
## Function will be called in each frame
func updateWater(springStiffnessConst, dampeningConst):
	# Update current height
	currHeight = position.y
	# Current extension of spring
	var springExtension = currHeight - targetHeight
	# Current loss of spring height (for loosing bounciness)
	var springLoss = - dampeningConst * currVelocity
	# Calculate force on spring using Hooke's Law (F = -k + x)
	springForce = - springStiffnessConst * springExtension + springLoss
	# Apply force to spring's current velocity
	currVelocity += springForce
	# Update spring's position based on velocity
	position.y += currVelocity
	pass

# Initialize spring
func initializeSpring(xPosSpring):
	currHeight = position.y
	targetHeight = position.y
	currVelocity = 0
	position.x = xPosSpring
	
