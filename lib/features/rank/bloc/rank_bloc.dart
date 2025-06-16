import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flight_sync_admin/core/base/api_service.dart';
import 'package:flight_sync_admin/core/constants/responses.dart';

part 'rank_event.dart';
part 'rank_state.dart';

class RankBloc extends Bloc<RankEvent, RankState> {
  RankBloc() : super(RankInitial()) {
    on<FetchRanks>(_onFetchRanks);
    on<DeleteRank>(_onDeleteRank);
    on<AddRank>(_onAddRank);
    on<SearchRank>(_onSearchRank);
  }

  ApiService apiService = ApiService();

  void _onFetchRanks(FetchRanks event, Emitter<RankState> emit) async {
    emit(state.copyWith(isLoading: true));
    final response = await apiService.fetchRanks();
    if (response.data != null) {
      final ranks = List<Rank>.from(response.data.map((e) => Rank.fromJson(e)));
      emit(
          state.copyWith(isLoading: false, ranks: ranks, originalRanks: ranks));
    } else {
      emit(state.copyWith(isLoading: false, error: response.message));
    }
  }

  void _onDeleteRank(DeleteRank event, Emitter<RankState> emit) async {
    emit(state.copyWith(isLoading: true));
    final response = await apiService.deleteRank(event.id);
    if (response.status == 'success') {
      final updatedOriginalList = List<Rank>.from(state.originalRanks ?? [])
        ..removeWhere((element) => element.id == event.id);
      final updatedFilteredList = List<Rank>.from(state.ranks ?? [])
        ..removeWhere((element) => element.id == event.id);

      emit(state.copyWith(
          isLoading: false,
          message: response.message,
          ranks: updatedFilteredList,
          originalRanks: updatedOriginalList));
    } else {
      emit(state.copyWith(isLoading: false, error: response.message));
    }
  }

  void _onAddRank(AddRank event, Emitter<RankState> emit) async {
    emit(state.copyWith(isLoading: true));
    final response = await apiService.addRank(data: event.rank.toMap());
    if (response.data != null) {
      final newRank = Rank.fromJson(response.data);
      final updatedOriginalList = List<Rank>.from(state.originalRanks ?? [])
        ..add(newRank);
      final updatedFilteredList = List<Rank>.from(state.ranks ?? [])
        ..add(newRank);

      emit(state.copyWith(
          isLoading: false,
          message: response.message,
          ranks: updatedFilteredList,
          originalRanks: updatedOriginalList));
    } else {
      emit(state.copyWith(isLoading: false, error: response.message));
    }
  }

  void _onSearchRank(SearchRank event, Emitter<RankState> emit) {
    if (state.originalRanks != null) {
      final filteredRanks = state.originalRanks!.where((rank) {
        final name = rank.name?.toLowerCase() ?? '';
        final query = event.query.toLowerCase();

        return name.contains(query);
      }).toList();

      emit(state.copyWith(
        ranks: filteredRanks,
        message: null,
      ));
    }
  }
}
