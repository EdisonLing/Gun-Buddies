extends Node

func random_in_percentage(base_number: float, percentage: float) -> float:
	# Calculate the range size
	var range_size: float = base_number * (percentage / 100.0)
	
	# Calculate min and max values
	var min_value: float = base_number - range_size
	var max_value: float = base_number + range_size
	
	# Return a random value within the range
	return randf_range(min_value, max_value)
