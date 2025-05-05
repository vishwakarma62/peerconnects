import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class CommunityEvent extends Equatable {
  const CommunityEvent();

  @override
  List<Object> get props => [];
}

class LoadGroups extends CommunityEvent {
  const LoadGroups();
}

class LoadEvents extends CommunityEvent {
  const LoadEvents();
}

class LoadNearbyWalkers extends CommunityEvent {
  const LoadNearbyWalkers();
}

class JoinGroup extends CommunityEvent {
  final String groupId;

  const JoinGroup({required this.groupId});

  @override
  List<Object> get props => [groupId];
}

class LeaveGroup extends CommunityEvent {
  final String groupId;

  const LeaveGroup({required this.groupId});

  @override
  List<Object> get props => [groupId];
}

class JoinEvent extends CommunityEvent {
  final String eventId;

  const JoinEvent({required this.eventId});

  @override
  List<Object> get props => [eventId];
}

class LeaveEvent extends CommunityEvent {
  final String eventId;

  const LeaveEvent({required this.eventId});

  @override
  List<Object> get props => [eventId];
}

class ConnectWithWalker extends CommunityEvent {
  final String walkerId;

  const ConnectWithWalker({required this.walkerId});

  @override
  List<Object> get props => [walkerId];
}

// States
abstract class CommunityState extends Equatable {
  const CommunityState();
  
  @override
  List<Object> get props => [];
}

class CommunityInitial extends CommunityState {
  const CommunityInitial();
}

class CommunityLoading extends CommunityState {
  const CommunityLoading();
}

class GroupsLoaded extends CommunityState {
  final List<Map<String, dynamic>> groups;

  const GroupsLoaded({required this.groups});

  @override
  List<Object> get props => [groups];
}

class EventsLoaded extends CommunityState {
  final List<Map<String, dynamic>> events;

  const EventsLoaded({required this.events});

  @override
  List<Object> get props => [events];
}

class NearbyWalkersLoaded extends CommunityState {
  final List<Map<String, dynamic>> walkers;

  const NearbyWalkersLoaded({required this.walkers});

  @override
  List<Object> get props => [walkers];
}

class GroupJoined extends CommunityState {
  final String groupId;

  const GroupJoined({required this.groupId});

  @override
  List<Object> get props => [groupId];
}

class GroupLeft extends CommunityState {
  final String groupId;

  const GroupLeft({required this.groupId});

  @override
  List<Object> get props => [groupId];
}

class EventJoined extends CommunityState {
  final String eventId;

  const EventJoined({required this.eventId});

  @override
  List<Object> get props => [eventId];
}

class EventLeft extends CommunityState {
  final String eventId;

  const EventLeft({required this.eventId});

  @override
  List<Object> get props => [eventId];
}

class WalkerConnected extends CommunityState {
  final String walkerId;

  const WalkerConnected({required this.walkerId});

  @override
  List<Object> get props => [walkerId];
}

class CommunityError extends CommunityState {
  final String message;

  const CommunityError({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  CommunityBloc() : super(const CommunityInitial()) {
    on<LoadGroups>(_onLoadGroups);
    on<LoadEvents>(_onLoadEvents);
    on<LoadNearbyWalkers>(_onLoadNearbyWalkers);
    on<JoinGroup>(_onJoinGroup);
    on<LeaveGroup>(_onLeaveGroup);
    on<JoinEvent>(_onJoinEvent);
    on<LeaveEvent>(_onLeaveEvent);
    on<ConnectWithWalker>(_onConnectWithWalker);
  }

  void _onLoadGroups(LoadGroups event, Emitter<CommunityState> emit) {
    emit(const CommunityLoading());
    try {
      // In a real app, you would load groups from a database or API
      // For now, we'll use sample data
      final List<Map<String, dynamic>> sampleGroups = [
        {
          'id': '1',
          'name': 'Morning Walk Group',
          'description': 'For early risers who enjoy morning walks',
          'members': 24,
          'isJoined': true,
        },
        {
          'id': '2',
          'name': 'Senior Citizens Walk',
          'description': 'Gentle walks for seniors in the community',
          'members': 18,
          'isJoined': false,
        },
        {
          'id': '3',
          'name': 'Weekend Walkers',
          'description': 'Group for weekend walking enthusiasts',
          'members': 32,
          'isJoined': true,
        },
        {
          'id': '4',
          'name': 'Nature Trails',
          'description': 'Explore nature trails and parks together',
          'members': 15,
          'isJoined': false,
        },
        {
          'id': '5',
          'name': 'Evening Strollers',
          'description': 'Relaxing evening walks after work',
          'members': 22,
          'isJoined': false,
        },
      ];
      emit(GroupsLoaded(groups: sampleGroups));
    } catch (e) {
      emit(CommunityError(message: e.toString()));
    }
  }

  void _onLoadEvents(LoadEvents event, Emitter<CommunityState> emit) {
    emit(const CommunityLoading());
    try {
      // In a real app, you would load events from a database or API
      // For now, we'll use sample data
      final List<Map<String, dynamic>> sampleEvents = [
        {
          'id': '1',
          'name': 'Community Walkathon',
          'time': 'Saturday, 8:00 AM',
          'location': 'Central Park',
          'description': 'A 5km walkathon to promote fitness in the community',
          'participants': 45,
          'isJoined': false,
        },
        {
          'id': '2',
          'name': 'Sunrise Walk',
          'time': 'Sunday, 6:30 AM',
          'location': 'Riverside Park',
          'description': 'Enjoy the beautiful sunrise while walking with friends',
          'participants': 12,
          'isJoined': true,
        },
        {
          'id': '3',
          'name': 'Charity Walk',
          'time': 'Next Friday, 9:00 AM',
          'location': 'Downtown',
          'description': 'Walk to raise funds for the local children\'s hospital',
          'participants': 78,
          'isJoined': false,
        },
        {
          'id': '4',
          'name': 'Nature Trail Exploration',
          'time': 'Next Saturday, 10:00 AM',
          'location': 'Forest Hills',
          'description': 'Explore the hidden trails of Forest Hills',
          'participants': 20,
          'isJoined': false,
        },
      ];
      emit(EventsLoaded(events: sampleEvents));
    } catch (e) {
      emit(CommunityError(message: e.toString()));
    }
  }

  void _onLoadNearbyWalkers(LoadNearbyWalkers event, Emitter<CommunityState> emit) {
    emit(const CommunityLoading());
    try {
      // In a real app, you would load nearby walkers from a database or API
      // For now, we'll use sample data
      final List<Map<String, dynamic>> sampleWalkers = [
        {
          'id': '1',
          'name': 'John Smith',
          'distance': '0.5 km away',
          'rating': '4.8',
          'isConnected': false,
        },
        {
          'id': '2',
          'name': 'Sarah Johnson',
          'distance': '0.8 km away',
          'rating': '4.9',
          'isConnected': true,
        },
        {
          'id': '3',
          'name': 'Michael Brown',
          'distance': '1.2 km away',
          'rating': '4.7',
          'isConnected': false,
        },
        {
          'id': '4',
          'name': 'Emma Wilson',
          'distance': '1.5 km away',
          'rating': '4.6',
          'isConnected': false,
        },
        {
          'id': '5',
          'name': 'David Lee',
          'distance': '2.0 km away',
          'rating': '4.8',
          'isConnected': true,
        },
      ];
      emit(NearbyWalkersLoaded(walkers: sampleWalkers));
    } catch (e) {
      emit(CommunityError(message: e.toString()));
    }
  }

  void _onJoinGroup(JoinGroup event, Emitter<CommunityState> emit) {
    try {
      // In a real app, you would update the database or API
      emit(GroupJoined(groupId: event.groupId));
      add(const LoadGroups());
    } catch (e) {
      emit(CommunityError(message: e.toString()));
    }
  }

  void _onLeaveGroup(LeaveGroup event, Emitter<CommunityState> emit) {
    try {
      // In a real app, you would update the database or API
      emit(GroupLeft(groupId: event.groupId));
      add(const LoadGroups());
    } catch (e) {
      emit(CommunityError(message: e.toString()));
    }
  }

  void _onJoinEvent(JoinEvent event, Emitter<CommunityState> emit) {
    try {
      // In a real app, you would update the database or API
      emit(EventJoined(eventId: event.eventId));
      add(const LoadEvents());
    } catch (e) {
      emit(CommunityError(message: e.toString()));
    }
  }

  void _onLeaveEvent(LeaveEvent event, Emitter<CommunityState> emit) {
    try {
      // In a real app, you would update the database or API
      emit(EventLeft(eventId: event.eventId));
      add(const LoadEvents());
    } catch (e) {
      emit(CommunityError(message: e.toString()));
    }
  }

  void _onConnectWithWalker(ConnectWithWalker event, Emitter<CommunityState> emit) {
    try {
      // In a real app, you would update the database or API
      emit(WalkerConnected(walkerId: event.walkerId));
      add(const LoadNearbyWalkers());
    } catch (e) {
      emit(CommunityError(message: e.toString()));
    }
  }
}