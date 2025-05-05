import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

class UpdateProfile extends ProfileEvent {
  final String name;
  final String email;
  final String bio;
  final String? profilePicture;

  const UpdateProfile({
    required this.name,
    required this.email,
    this.bio = '',
    this.profilePicture,
  });

  @override
  List<Object> get props => [name, email, bio];
}

class LoadAchievements extends ProfileEvent {
  const LoadAchievements();
}

class LoadFriends extends ProfileEvent {
  const LoadFriends();
}

class LoadActivity extends ProfileEvent {
  const LoadActivity();
}

// States
abstract class ProfileState extends Equatable {
  const ProfileState();
  
  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final String name;
  final String email;
  final String bio;
  final String? profilePicture;
  final Map<String, dynamic> stats;

  const ProfileLoaded({
    required this.name,
    required this.email,
    this.bio = '',
    this.profilePicture,
    required this.stats,
  });

  @override
  List<Object> get props => [name, email, bio, stats];
}

class ProfileUpdated extends ProfileState {
  const ProfileUpdated();
}

class AchievementsLoaded extends ProfileState {
  final List<Map<String, dynamic>> achievements;

  const AchievementsLoaded({required this.achievements});

  @override
  List<Object> get props => [achievements];
}

class FriendsLoaded extends ProfileState {
  final List<Map<String, dynamic>> friends;

  const FriendsLoaded({required this.friends});

  @override
  List<Object> get props => [friends];
}

class ActivityLoaded extends ProfileState {
  final List<Map<String, dynamic>> activities;

  const ActivityLoaded({required this.activities});

  @override
  List<Object> get props => [activities];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<LoadAchievements>(_onLoadAchievements);
    on<LoadFriends>(_onLoadFriends);
    on<LoadActivity>(_onLoadActivity);
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) {
    emit(const ProfileLoading());
    try {
      // In a real app, you would load profile from a database or API
      // For now, we'll use sample data
      emit(ProfileLoaded(
        name: 'John Smith',
        email: 'john.smith@example.com',
        bio: 'Enthusiastic walker who enjoys morning strolls and community events.',
        stats: {
          'totalWalks': 42,
          'totalDistance': 156.8,
          'totalDuration': '24:30',
        },
      ));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  void _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) {
    emit(const ProfileLoading());
    try {
      // In a real app, you would update profile in a database or API
      emit(const ProfileUpdated());
      emit(ProfileLoaded(
        name: event.name,
        email: event.email,
        bio: event.bio,
        profilePicture: event.profilePicture,
        stats: {
          'totalWalks': 42,
          'totalDistance': 156.8,
          'totalDuration': '24:30',
        },
      ));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  void _onLoadAchievements(LoadAchievements event, Emitter<ProfileState> emit) {
    try {
      // In a real app, you would load achievements from a database or API
      // For now, we'll use sample data
      final List<Map<String, dynamic>> sampleAchievements = [
        {
          'id': '1',
          'title': 'Early Bird',
          'description': '10 morning walks',
          'icon': 'wb_sunny',
          'color': 'orange',
          'earned': true,
        },
        {
          'id': '2',
          'title': 'Consistent',
          'description': '5 days streak',
          'icon': 'calendar_today',
          'color': 'blue',
          'earned': true,
        },
        {
          'id': '3',
          'title': 'Explorer',
          'description': '5 different routes',
          'icon': 'explore',
          'color': 'purple',
          'earned': true,
        },
        {
          'id': '4',
          'title': 'Social',
          'description': '3 group walks',
          'icon': 'group',
          'color': 'green',
          'earned': true,
        },
        {
          'id': '5',
          'title': 'Milestone',
          'description': '100 km walked',
          'icon': 'flag',
          'color': 'red',
          'earned': true,
        },
      ];
      emit(AchievementsLoaded(achievements: sampleAchievements));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  void _onLoadFriends(LoadFriends event, Emitter<ProfileState> emit) {
    try {
      // In a real app, you would load friends from a database or API
      // For now, we'll use sample data
      final List<Map<String, dynamic>> sampleFriends = [
        {
          'id': '1',
          'name': 'Sarah',
          'profilePicture': null,
        },
        {
          'id': '2',
          'name': 'Mike',
          'profilePicture': null,
        },
        {
          'id': '3',
          'name': 'Emma',
          'profilePicture': null,
        },
        {
          'id': '4',
          'name': 'David',
          'profilePicture': null,
        },
        {
          'id': '5',
          'name': 'Lisa',
          'profilePicture': null,
        },
      ];
      emit(FriendsLoaded(friends: sampleFriends));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  void _onLoadActivity(LoadActivity event, Emitter<ProfileState> emit) {
    try {
      // In a real app, you would load activity from a database or API
      // For now, we'll use sample data
      final List<Map<String, dynamic>> sampleActivities = [
        {
          'id': '1',
          'activity': 'You completed a 3.2 km walk',
          'time': 'Today, 7:30 AM',
          'icon': 'directions_walk',
        },
        {
          'id': '2',
          'activity': 'You joined Morning Walk Group',
          'time': 'Yesterday, 6:15 PM',
          'icon': 'group_add',
        },
        {
          'id': '3',
          'activity': 'You earned the Early Bird badge',
          'time': '2 days ago, 8:00 AM',
          'icon': 'emoji_events',
        },
      ];
      emit(ActivityLoaded(activities: sampleActivities));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}