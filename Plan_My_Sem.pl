% This line consults the knowledge bases from this file,
% instead of needing to consult the files individually.
% This line MUST be included in the final submission.
:- ['transport_kb', 'slots_kb'].



%code for froup_days:
group_helper(Group, day_timing(Week, Day)):-
    scheduled_slot(Week, Day, _, _, Group).

group_days(Group, List):-
    bagof(day_timing(Week, Day), group_helper(Group, day_timing(Week, Day)), Bag),
    remove_duplicates(Bag, List).

remove_duplicates([], []).
remove_duplicates([X|Xs], Unique) :-
    member(X, Xs),
    !,
    remove_duplicates(Xs, Unique).
remove_duplicates([X|Xs], [X|Unique]) :-
    remove_duplicates(Xs, Unique).


%code for day slot:
day_slots_helper(Group, Week, Day, Slots):-
    scheduled_slot(Week, Day, Slots, _, Group).
    
day_slots(Group, Week, Day, S):-
    setof(Slots ,day_slots_helper(Group, Week, Day, Slots),S).

%code for earliest slots:
earliest_slot(Group, Week, Day, H):-
    day_slots(Group, Week, Day , [H|T]).

    


%code for append connection:
delete_last(List, Result) :-
    append(Result, [_], List).

append_connection(Conn_Source, Conn_Destination, Conn_Duration, Conn_Line, [], [route(Conn_Line,Conn_Source,Conn_Destination,Conn_Duration)]).

append_connection(Conn_Source, Conn_Destination, Conn_Duration, Conn_Line, Routes_So_Far, Routes):-
    Conn_Line\=s41 ,Conn_Line\=s42,
    \+member(route(Conn_Line,Conn_Source,Conn_Destination,_),Routes_So_Far),
    \+member(route(Conn_Line,Conn_Destination,Conn_Source,_),Routes_So_Far),
    
    last(Routes_So_Far,route(Conn_Line1, Conn_Source1, Conn_Destination1, Conn_Duration1 ) ),
    Conn_Source=Conn_Destination1,
    Conn_Line =Conn_Line1,
    D is Conn_Duration +Conn_Duration1,
    X =Conn_Source1,
    proper_connection(Conn_Source, Conn_Destination, Conn_Duration, Conn_Line),
    delete_last(Routes_So_Far, R),
    append(R,[route(Conn_Line, X, Conn_Destination, D )], Routes ).


append_connection(Conn_Source, Conn_Destination, Conn_Duration, Conn_Line, Routes_So_Far, Routes):-
    Conn_Line\=s41 ,Conn_Line\=s42,
    \+member(route(Conn_Line,Conn_Source,Conn_Destination,_),Routes_So_Far),
    \+member(route(Conn_Line,Conn_Destination,Conn_Source,_),Routes_So_Far),
    
    last(Routes_So_Far,route(Conn_Line1, Conn_Source1, Conn_Destination1, Conn_Duration1 ) ),
    (Conn_Source\=Conn_Destination1;
    Conn_Line \=Conn_Line1),
    proper_connection(Conn_Source, Conn_Destination, Conn_Duration, Conn_Line),
    append(Routes_So_Far,[route(Conn_Line, Conn_Source, Conn_Destination, Conn_Duration )], Routes ).

append_connection(Conn_Source, Conn_Destination, Conn_Duration, Conn_Line, Routes_So_Far, Routes):-
   ( Conn_Line=s41 ;Conn_Line=s42),
    \+member(route(s41,Conn_Source,Conn_Destination,_),Routes_So_Far),
    \+member(route(s42,Conn_Destination,Conn_Source,_),Routes_So_Far),
    \+member(route(s42,Conn_Source,Conn_Destination,_),Routes_So_Far),
    \+member(route(s41,Conn_Destination,Conn_Source,_),Routes_So_Far),

    last(Routes_So_Far,route(Conn_Line1, Conn_Source1, Conn_Destination1, Conn_Duration1 ) ),
    Conn_Source=Conn_Destination1,
    Conn_Line =Conn_Line1,
    D is Conn_Duration +Conn_Duration1,
    X =Conn_Source1,
    proper_connection(Conn_Source, Conn_Destination, Conn_Duration, Conn_Line),
    delete_last(Routes_So_Far, R),
    append(R,[route(Conn_Line, X, Conn_Destination, D )], Routes ).


append_connection(Conn_Source, Conn_Destination, Conn_Duration, Conn_Line, Routes_So_Far, Routes):-
    ( Conn_Line=s41 ;Conn_Line=s42),
    \+member(route(s41,Conn_Source,Conn_Destination,_),Routes_So_Far),
    \+member(route(s42,Conn_Destination,Conn_Source,_),Routes_So_Far),
    \+member(route(s42,Conn_Source,Conn_Destination,_),Routes_So_Far),
    \+member(route(s41,Conn_Destination,Conn_Source,_),Routes_So_Far),
    last(Routes_So_Far,route(Conn_Line1, Conn_Source1, Conn_Destination1, Conn_Duration1 ) ),
    (Conn_Source\=Conn_Destination1;
    Conn_Line \=Conn_Line1),
    proper_connection(Conn_Source, Conn_Destination, Conn_Duration, Conn_Line),
    append(Routes_So_Far,[route(Conn_Line, Conn_Source, Conn_Destination, Conn_Duration )], Routes ).


%code for proper_connection:
proper_connection(Station_A, Station_B, Duration, Line):-
    (connection(Station_A, Station_B, Duration, Line); connection(Station_B, Station_A, Duration, Line)),
    \+ unidirectional(Line).
        
proper_connection(Station_A, Station_B, Duration, Line):-
    (connection(Station_A, Station_B, Duration, Line)),
    unidirectional(Line).

%connected code :connected(Source,Destination,Week,Day,MaxDuration,MaxRoutes,Duration,Routes):-
connected(Source,Destination,Week,Day,MaxDuration,MaxRoutes,Duration,Routes):-
    connected(Source,Destination,Week,Day,MaxDuration,MaxRoutes,Duration,Routes,0,[],[]). 


connected(Source,Source,Week, Day, MaxDuration, MaxRoutes, Acc1, Acc2,Acc1,Acc2,Acc3):- Acc1 =< MaxDuration.
connected(Source,Destination,Week, Day, MaxDuration, MaxRoutes, Duration, Routes,Acc1,Acc2,Acc3):- % connected 11
    Source\= Destination,
    Acc1 <MaxDuration,
    proper_connection(Source,X, D, L),
    \+ member(X, Acc3),
    append([X],Acc3,Acc3New),
    line( L, Type),
    \+ strike(Type,Week, Day),
    append_connection(Source,X,D,L,Acc2,Acc2New),
    length(Acc2 ,Len),
    Len =<MaxRoutes, 
    AccNew1 is D+Acc1,
    connected(X,Destination,Week, Day, MaxDuration, MaxRoutes,Duration,Routes,AccNew1,Acc2New,Acc3New).


connected(Source,Destination,Week,Day,MaxDuration,MaxRoutes,Duration,Visited_stations,CurrentRoutes,Routes):- % connected 10
    connected(Source,Destination,Week, Day, MaxDuration, MaxRoutes, Duration, Routes,0,CurrentRoutes,Routes). % connected 11

% connected(amrumer_str, leopoldplatz, 1, mon, 2, 1, 2, [westhafen], [route(u9,westhafen, amrumer_str, 1)], [route(u9, westhafen, leopoldplatz, 3)]).

%version 2:
% connected(Source,Destination,Week, Day, MaxDuration, MaxRoutes, Duration, Routes,CurrentDuration,CurrentRoutes,Acc3):- %connected/11
%     Source\= Destination,
%     CurrentDuration =<MaxDuration,
%     proper_connection(Source,X, D, L),
%     \+ member(X, Acc3),
%     append([X],Acc3,Acc3New), 
%     line( L, Type),
%     \+ strike(Type,Week, Day),
%     append_connection(Source,X,D,L,CurrentRoutes,NewCurrentRoutes),
%     length(CurrentRoutes ,Len),
%     Len =<MaxRoutes, 
%     NewCurrentDuration is D+CurrentDuration,
%     connected(X,Destination,Week, Day, MaxDuration, MaxRoutes,Duration,Routes,NewCurrentDuration,NewCurrentRoutes,Acc3New).




%conversions
mins_to_twentyfour_hr(Minutes, TwentyFour_Hours, TwentyFour_Mins):-
    TwentyFour_Hours is Minutes // 60,
    TwentyFour_Mins is Minutes mod 60.

twentyfour_hr_to_mins(TwentyFour_Hours, TwentyFour_Mins, Minutes):-
    Minutes is TwentyFour_Hours *60 + TwentyFour_Mins.

slot_to_mins(Slot_Num, Minutes):-
    slot(Slot_Num, Hours, Mins ),
    twentyfour_hr_to_mins(Hours, Mins, Minutes).


% Main predicate 

% travel_plan(_, Group, _, _, []):-
%     group_days(Group, []).

% travel_plan([First_home_station|Rest_of_homestations], Group, Max_Duration, Max_Routes, Journeys):-
%     group_days(Group, [First_day| Rest_of_days]),  [day1 , day2 ......]
%     travel_plan_helper()


travel_plan(Home_Stations,Group,Max_Duration,Max_Routes,Journeys):-
    group_days(Group, Result),
    travel_plan_helper(Home_Stations, Group, Max_Duration, Max_Routes,Journeys, Result).


% Base case: If the list of days is empty, terminate.
travel_plan_helper(_, _, _, _, [], []).

% Recursive case: Try different starting stations for each day.
travel_plan_helper(Home_Stations, Group, Max_Duration, Max_Routes, [journey(Week, Day,Hours_to_arrive,Minutes_to_arrive,Total_duration,Routes) | Rest_Journeys], [This_day | Rest_of_days]) :-
    This_day = day_timing(Week, Day),
    earliest_slot(Group,Week,Day,Earliest_slot),
    member(Station, Home_Stations),
    campus_reachable(X),
    connected(Station, X, Week, Day, Max_Duration, Max_Routes, Total_duration, Routes),
    %calculating time:
    slot(Earliest_slot,Hour, Min),
    twentyfour_hr_to_mins(Hour,Min,First_slot_minutes),
    Total_minutes is First_slot_minutes -Total_duration,
    mins_to_twentyfour_hr(Total_minutes,Hours_to_arrive,Minutes_to_arrive),
    % rest of recursion:
    travel_plan_helper(Home_Stations, Group, Max_Duration, Max_Routes, Rest_Journeys, Rest_of_days).


