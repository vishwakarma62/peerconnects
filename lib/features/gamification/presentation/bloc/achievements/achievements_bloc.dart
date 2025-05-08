import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peer_connects/features/gamification/domain/entities/achievement_entity.dart';
import 'package:peer_connects/features/gamification/domain/usecases/get_achievements.dart';

// Events
abstract class AchievementsEvent extends Equatable {
  const AchievementsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllAchievements extends AchievementsEvent {
  const LoadAllAchievements();
}

class LoadUserAchievements extends AchievementsEvent {
  final String userId;
  
  const LoadUserAchievements(this.userId);
  
  @override
  List<Object?> get props => [userId];
}

class LoadAchievementsByCategory extends AchievementsEvent {
  final AchievementCategory category;
  
  const LoadAchievementsByCategory(this.category);
  
  @override
  List<Object?> get props => [category];
}

// States
abstract class AchievementsState extends Equatable {
  const AchievementsState();
  
  @override
  List<Object?> get props => [];
}

class AchievementsInitial extends AchievementsState {
  const AchievementsInitial();
}

class AchievementsLoading extends AchievementsState {
  const AchievementsLoading();
}

class AchievementsLoaded extends AchievementsState {
  final List<AchievementEntity> achievements;
  final bool isUserAchievements;
  final AchievementCategory? category;
  
  const AchievementsLoaded({
    required this.achievements,
    this.isUserAchievements = false,
    this.category,
  });
  
  @override
  List<Object?> get props => [achievements, isUserAchievements, category];
}

class AchievementsError extends AchievementsState {
  final String message;
  
  const AchievementsError(this.message);
  
  @override
  List<Object?> get props => [message];
}

// BLoC
class AchievementsBloc extends Bloc<AchievementsEvent, AchievementsState> {
  final GetAchievements getAchievements;
  
  AchievementsBloc({required this.getAchievements}) 
      : super(const AchievementsInitial()) {
    on<LoadAllAchievements>(_onLoadAllAchievements);
    on<LoadUserAchievements>(_onLoadUserAchievements);
    on<LoadAchievementsByCategory>(_onLoadAchievementsByCategory);
  }
  
  void _onLoadAllAchievements(
    LoadAllAchievements event,
    Emitter<AchievementsState> emit,
  ) async {
    emit(const AchievementsLoading());
    try {
      final achievements = await getAchievements();
      emit(AchievementsLoaded(achievements: achievements));
    } catch (e) {
      emit(AchievementsError(e.toString()));
    }
  }
  
  void _onLoadUserAchievements(
    LoadUserAchievements event,
    Emitter<AchievementsState> emit,
  ) async {
    emit(const AchievementsLoading());
    try {
      final achievements = await getAchievements.forUser(event.userId);
      emit(AchievementsLoaded(
        achievements: achievements,
        isUserAchievements: true,
      ));
    } catch (e) {
      emit(AchievementsError(e.toString()));
    }
  }
  
  void _onLoadAchievementsByCategory(
    LoadAchievementsByCategory event,
    Emitter<AchievementsState> emit,
  ) async {
    emit(const AchievementsLoading());
    try {
      final achievements = await getAchievements.byCategory(event.category);
      emit(AchievementsLoaded(
        achievements: achievements,
        category: event.category,
      ));
    } catch (e) {
      emit(AchievementsError(e.toString()));
    }
  }
}