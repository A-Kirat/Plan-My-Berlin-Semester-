
# Plan My Berlin Semester - README

## Overview

This Prolog-based system helps generate travel plans for groups based on their schedules and the available transport network. The system computes optimal routes from a list of home stations to the destination (campus) while considering route durations, time slots, and constraints on the maximum number of routes and travel duration.

The system uses predefined knowledge bases, `transport_kb.pl` for transport connections and `slots_kb.pl` for group schedules.

## Key Features

- **Group Activity Days (`group_days`)**: Determines the days and times when a specific group has scheduled activities.
- **Day Slot Finder (`day_slots`)**: Retrieves all available time slots for a group on a given day.
- **Earliest Slot Finder (`earliest_slot`)**: Finds the earliest available time slot for a group on a specific day.
- **Connection Finder (`append_connection`)**: Appends valid connections between stations while avoiding route duplication.
- **Proper Connection Validation (`proper_connection`)**: Ensures that the connection between two stations is valid according to the transport network.
- **Travel Plan Generation (`travel_plan`)**: Generates a detailed travel plan for a group by calculating optimal routes and times for reaching the campus based on group schedules.

## Knowledge Bases

- **`transport_kb.pl`**: Defines the transport network, including routes, connections between stations, the duration of the trips, and whether the routes are bidirectional or unidirectional.
- **`slots_kb.pl`**: Defines the scheduled slots for different groups, including the week, day, and time of their activities.
## Main Predicates

### Day Slots
day_slots(Group, Week, Day, S)

- **Description**: 
  - `day_slots_helper(Group, Week, Day, Slots)` is a helper predicate that checks for the scheduled slot of a group on a particular week and day.
  - `day_slots(Group, Week, Day, S)` returns a set of available time slots for a given group on a particular day and week.

### Earliest Slot
earliest_slot(Group, Week, Day, H) :-

- **Description**: 
  - `earliest_slot(Group, Week, Day, H)` finds the earliest time slot available for a group in a specified week and day. It uses the `day_slots` predicate and extracts the first (earliest) slot.

### Append Connection
```prolog
append_connection(Conn_Source, Conn_Destination, Conn_Duration, Conn_Line, [], [route(Conn_Line, Conn_Source, Conn_Destination, Conn_Duration)]).

```
- **Description**: 
  - `delete_last(List, Result)` removes the last element from a list.
  - `append_connection/6` appends a connection between two stations to the list of routes. It prevents duplicate routes and handles route accumulation correctly, ensuring connections are only added if they meet the conditions of being valid (i.e., not on restricted lines such as `s41` or `s42`).

### Proper Connection
```prolog
proper_connection(Station_A, Station_B, Duration, Line) 
```
- **Description**: 
  - `proper_connection/4` checks if a valid connection exists between two stations (`Station_A` and `Station_B`). It considers bidirectional routes and validates unidirectional ones accordingly.

### Connected
```prolog
connected(Source, Destination, Week, Day, MaxDuration, MaxRoutes, Duration, Routes) :-
    connected(Source, Destination, Week, Day, MaxDuration, MaxRoutes, Duration, Routes, 0, [], []).
```
- **Description**: 
  - `connected/7` finds a valid route from `Source` to `Destination` in a specific `Week` and `Day`, considering constraints on the maximum duration and number of routes. It returns the total travel duration and the list of routes taken. The predicate recursively explores connections, ensuring the best route is selected based on the constraints.
```


