####################
# Author: Robert Petit
# Desc: Takes the .csv output by https://github.com/Tyrrrz/DiscordChatExporter 
# skims off the relevant messages, and converts them to the format (Name, Week, Day, FrodoMiles, Workout, Distance, Time)
# We use the cleaned version for all other analysis.
####################

read.csv(here("Data/RawMessages.csv")) %>% 
  # Only two columns that matter for now
  # We drop author later, but it's useful for debugging for now
  
  select(Author, Content) %>%
  # Note that this is startsWith not starts_with. This is a string function
  filter(startsWith(Content, "Name")) %>%
  
  # Because there are square brackets, we use a regex to drop them in gsub.
  # If, in the future, other content needs to be dropped
  # Do it with a second mutate and str_remove_all() if possible
  mutate(Content = gsub("\\[|\\]", "", Content)) %>%
  
  # This ensures that all parenthetical information gets converted, even with a lack of space
  # It pairs with the next line to work properly. gsub because nested regex hates "\\("
  mutate(Content = gsub("\\(|\\)", " ", Content)) %>%
  
  # Some people have two spaces instead of one in critical spots
  # Also pairs with the above to avoid parentheses in messages
  mutate(Content= str_replace_all(Content, "  ", " ")) %>%
  
  # Splitting on \n
  mutate(Content= str_split(Content, "\n")) %>%
  rowwise() %>%
  
  # We opt to rely on white space here to get the appropriate values.
  # This should be checked each time manually to control for anomalies
  # Note that this solution also depends on everyone having the appropriate *order* to their messages, which may not hold
  # If people do wild things, either ask them to fix and stop, or swap to selecting based on startsWith() and the key
  mutate(Name = Content[1],
         Workout = Content[2],
         Distance = Content[3],
         Time = Content[4],
         Day = Content[5],
         Week = Content[6],) %>%
  
  select(-Author, -Content) %>%
  # everything becomes lower case before we touch it
  mutate(across(.cols=everything(), tolower)) %>%
  
  # Preparing to isolate the values
  mutate(across(.cols=everything(), str_split, " ")) %>%
  # This drops the "Name: " etc. in front of each value
  mutate(Name = Name[2],
         Workout = Workout[2],
         Distance = Distance[2],
         Time = Time[2],
         Day = Day[2],
         Week = Week[2]) %>%
  ungroup() %>%
  
  # We need to drop the format message
  filter(Name != "namehere") %>%
  
  # Converting from string to duration
  rowwise() %>%
  mutate(Time = str_split(Time, ":")) %>%
  
  # Using negative indices to lay the groundwork for adding hours to the mix
  # If hours are used, we can just extend short lists from the front
  mutate(Time = duration(
                minutes=as.numeric(Time[-2]),
                seconds=as.numeric(Time[-1])),
         Time = as.numeric(Time)) %>% # Convert to a numeric (In terms of seconds)
  ungroup() %>%
  mutate(Distance = as.numeric(Distance)) %>%
  
  rowwise() %>%
  #mutate(Workout = factor(Workout, levels = c("run", "bike","swim", "row"))) %>%
  mutate(FrodoMiles = FrodoConversion(Distance, Time, Workout)) %>%
  ungroup() %>%
  
  # Insert capitalization
  mutate(across(.cols=where(is.character), str_to_title)) %>%
  
  #Lastly, order the variables
  select(Name, Week, Day, FrodoMiles, Workout, Distance, Time) %>%
  write_csv(here("Data/Workouts.csv"))
