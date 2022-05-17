FrodoConversion <- function(Distance, Time, Workout) {
  # Eventually, we want to convert distance based on pace. At this stage, flat conversions work
  # A lot of these are based on bar-napkin math of average pace ratios (which is probably not good)
  if (Workout=="run") {
    return(Distance)
    
  } else if (Workout == "bike") {
    return(Distance * 0.33)
    
  } else if (Workout ==  "swim") {
    return(Distance*4)
    
  } else if (Workout == "row") {
    return(Distance*0.8)
    
  } else {
    return("BAD INPUT")
  }
}

Stats_PerPerson <- function(WorkoutTable) {
  WorkoutTable %>%
    group_by(Name) %>%
    summarize(TotalDistance = sum(FrodoMiles),
              TotalTime = sum(Time))
}
