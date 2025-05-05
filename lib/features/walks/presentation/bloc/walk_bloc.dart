import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class WalkEvent extends Equatable {
  const WalkEvent();

  @override
  List<Object> get props => [];
}

class StartWalk extends WalkEvent {
  const StartWalk();
}

class PauseWalk extends WalkEvent {
  const PauseWalk();
}

class ResumeWalk extends WalkEvent {
  const ResumeWalk();
}

class StopWalk extends WalkEvent {
  const StopWalk();
}

class UpdateWalkStats extends WalkEvent {
  final double distance;
  final int duration;
  final double pace;
  final int calories;

  const UpdateWalkStats({
    required this.distance,
    required this.duration,
    required this.pace,
    required this.calories,
  });

  @override
  List<Object> get props => [distance, duration, pace, calories];
}

class SaveWalk extends WalkEvent {
  final String name;
  final String notes;

  const SaveWalk({
    required this.name,
    this.notes = '',
  });

  @override
  List<Object> get props => [name, notes];
}

class LoadWalks extends WalkEvent {
  const LoadWalks();
}

// States
abstract class WalkState extends Equatable {
  const WalkState();
  
  @override
  List<Object> get props => [];
}

class WalkInitial extends WalkState {
  const WalkInitial();
}

class WalkInProgress extends WalkState {
  final double distance;
  final int duration;
  final double pace;
  final int calories;
  final bool isPaused;

  const WalkInProgress({
    this.distance = 0.0,
    this.duration = 0,
    this.pace = 0.0,
    this.calories = 0,
    this.isPaused = false,
  });

  WalkInProgress copyWith({
    double? distance,
    int? duration,
    double? pace,
    int? calories,
    bool? isPaused,
  }) {
    return WalkInProgress(
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      pace: pace ?? this.pace,
      calories: calories ?? this.calories,
      isPaused: isPaused ?? this.isPaused,
    );
  }

  @override
  List<Object> get props => [distance, duration, pace, calories, isPaused];
}

class WalkCompleted extends WalkState {
  final double distance;
  final int duration;
  final double pace;
  final int calories;

  const WalkCompleted({
    required this.distance,
    required this.duration,
    required this.pace,
    required this.calories,
  });

  @override
  List<Object> get props => [distance, duration, pace, calories];
}

class WalkSaved extends WalkState {
  const WalkSaved();
}

class WalksLoaded extends WalkState {
  final List<Map<String, dynamic>> walks;

  const WalksLoaded({required this.walks});

  @override
  List<Object> get props => [walks];
}

class WalkError extends WalkState {
  final String message;

  const WalkError({required this.message});

  @override
  List<Object> get props => [message];
}

// BLoC
class WalkBloc extends Bloc<WalkEvent, WalkState> {
  WalkBloc() : super(const WalkInitial()) {
    on<StartWalk>(_onStartWalk);
    on<PauseWalk>(_onPauseWalk);
    on<ResumeWalk>(_onResumeWalk);
    on<StopWalk>(_onStopWalk);
    on<UpdateWalkStats>(_onUpdateWalkStats);
    on<SaveWalk>(_onSaveWalk);
    on<LoadWalks>(_onLoadWalks);
  }

  void _onStartWalk(StartWalk event, Emitter<WalkState> emit) {
    emit(const WalkInProgress());
  }

  void _onPauseWalk(PauseWalk event, Emitter<WalkState> emit) {
    if (state is WalkInProgress) {
      final currentState = state as WalkInProgress;
      emit(currentState.copyWith(isPaused: true));
    }
  }

  void _onResumeWalk(ResumeWalk event, Emitter<WalkState> emit) {
    if (state is WalkInProgress) {
      final currentState = state as WalkInProgress;
      emit(currentState.copyWith(isPaused: false));
    }
  }

  void _onStopWalk(StopWalk event, Emitter<WalkState> emit) {
    if (state is WalkInProgress) {
      final currentState = state as WalkInProgress;
      emit(WalkCompleted(
        distance: currentState.distance,
        duration: currentState.duration,
        pace: currentState.pace,
        calories: currentState.calories,
      ));
    }
  }

  void _onUpdateWalkStats(UpdateWalkStats event, Emitter<WalkState> emit) {
    if (state is WalkInProgress) {
      final currentState = state as WalkInProgress;
      emit(currentState.copyWith(
        distance: event.distance,
        duration: event.duration,
        pace: event.pace,
        calories: event.calories,
      ));
    }
  }

  void _onSaveWalk(SaveWalk event, Emitter<WalkState> emit) {
    if (state is WalkCompleted) {
      // In a real app, you would save the walk to a database
      emit(const WalkSaved());
      emit(const WalkInitial());
    }
  }

  void _onLoadWalks(LoadWalks event, Emitter<WalkState> emit) {
    try {
      // In a real app, you would load walks from a database
      // For now, we'll use sample data
      final List<Map<String, dynamic>> sampleWalks = [
        {
          'id': '1',
          'date': 'Today',
          'time': '7:30 AM',
          'distance': '3.2',
          'duration': '32:45',
          'type': 'solo',
          'route': 'Morning Route',
        },
        {
          'id': '2',
          'date': 'Yesterday',
          'time': '6:15 PM',
          'distance': '2.8',
          'duration': '28:12',
          'type': 'group',
          'route': 'Evening Group Walk',
        },
        {
          'id': '3',
          'date': '2 days ago',
          'time': '8:00 AM',
          'distance': '4.5',
          'duration': '45:30',
          'type': 'solo',
          'route': 'Park Loop',
        },
      ];
      emit(WalksLoaded(walks: sampleWalks));
    } catch (e) {
      emit(WalkError(message: e.toString()));
    }
  }
}