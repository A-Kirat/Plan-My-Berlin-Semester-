
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


