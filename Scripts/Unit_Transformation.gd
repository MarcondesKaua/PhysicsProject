extends Node
const DISTANCE_TO_PIXEL : float = 50.0

func ds_to_px (ds : float ) -> float: 
	return ds * DISTANCE_TO_PIXEL
	
func px_to_ds (px : float) -> float:
	return px / DISTANCE_TO_PIXEL
