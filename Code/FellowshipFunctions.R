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

Stats_PerPerson <- function(WorkoutTable, ThisWeek) {
  # This was re factored after Week 2, Vis is up to date, W1 writeup is not
  
  WorkoutTable %>%
    
    # But we make two new columns for distance and time, one that is non-0 if the workout occurred this week
    # And a single lagged week. Later, we can summarize the current/lag by just summing those columns
    # Probably a haphazard way to do this (there is clever summarize syntax I am certain)
    mutate(WeeklyMiles = ifelse(Week==ThisWeek, FrodoMiles, 0),
           LaggedWeeklyMiles = ifelse(Week==ThisWeek-1, FrodoMiles, 0),
           
           WeeklyTime = ifelse(Week==ThisWeek, Time, 0),
           LaggedWeeklyTime = ifelse(Week==ThisWeek-1, Time, 0)) %>%
    group_by(Name) %>%
    
    summarize(TotalDistance = sum(FrodoMiles),
              WeeklyDistance = sum(WeeklyMiles),
              LagWeeklyDistance = sum(LaggedWeeklyMiles), #See above mutate()
              
              TotalTime = sum(Time),
              WeeklyTime = sum(WeeklyTime),
              LaggedWeeklyTime = sum(LaggedWeeklyTime))
}
