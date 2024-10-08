import 'dart:async';

import 'package:cortes_energia/domain/models/cortes_luz_information.dart';
import 'package:cortes_energia/domain/models/criterio.dart';
import 'package:cortes_energia/domain/repository/cortes_luz_repository.dart';
import 'package:cortes_energia/domain/repository/documents_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

enum HomeStatus {
  initial,
  loading,
  success,
  error,
}

final class HomeState {
  final String criterio;
  final String documento;
  final HomeStatus status;
  final CortesLuzInformation? information;

  HomeState({
    required this.criterio,
    required this.documento,
    required this.status,
    required this.information,
  });

  factory HomeState.empty() {
    return HomeState(
      criterio: Criterio.cuentaContrato.value,
      documento: "",
      status: HomeStatus.initial,
      information: null,
    );
  }

  HomeState copyWith({
    String? criterio,
    String? documento,
    HomeStatus? status,
    CortesLuzInformation? information,
  }) {
    return HomeState(
      criterio: criterio ?? this.criterio,
      documento: documento ?? this.documento,
      status: status ?? this.status,
      information: information ?? this.information,
    );
  }
}

sealed class HomeEvent {}

final class CriterioChanged extends HomeEvent {
  final String criterio;

  CriterioChanged({required this.criterio});
}

final class DocumentoChanged extends HomeEvent {
  final String documento;

  DocumentoChanged({required this.documento});
}

final class ConsultarHorarios extends HomeEvent {}

final class GetMostRecentDocumentNumber extends HomeEvent {}

enum UiMessageKind {
  error,
  success,
  documentNumber,
}

final class UiMessage {
  final UiMessageKind type;
  final String message;

  UiMessage({required this.type, required this.message});
}

class HomeViewModel extends Bloc<HomeEvent, HomeState> {
  final StreamController<UiMessage> _messages = StreamController.broadcast();
  final CortesLuzRepository _cortesLuz;
  final DocumentsRepository _documents;

  Stream<UiMessage> get messages => _messages.stream;

  HomeViewModel(this._cortesLuz, this._documents) : super(HomeState.empty()) {
    on<CriterioChanged>(_onCriterioChanged);
    on<DocumentoChanged>(_onDocumentoChanged);
    on<ConsultarHorarios>(_onConsultarHorarios);
    on<GetMostRecentDocumentNumber>(_onGetMostRecentDocumentNumber);
  }

  @override
  Future<void> close() {
    _messages.close();
    return super.close();
  }

  FutureOr<void> _onDocumentoChanged(
    DocumentoChanged event,
    Emitter<HomeState> emit,
  ) {
    emit(
      state.copyWith(
        documento: event.documento,
      ),
    );
  }

  FutureOr<void> _onCriterioChanged(
    CriterioChanged event,
    Emitter<HomeState> emit,
  ) {
    emit(
      state.copyWith(
        criterio: event.criterio,
      ),
    );
  }

  FutureOr<void> _onConsultarHorarios(
    ConsultarHorarios event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        status: HomeStatus.loading,
      ),
    );

    final result = await _cortesLuz.consultarCortesLuz(
      state.documento,
      state.criterio,
    );

    switch (result) {
      case Left(value: final error):
        emit(
          state.copyWith(
            status: HomeStatus.error,
          ),
        );
        _messages.add(
          UiMessage(
            type: UiMessageKind.error,
            message: error,
          ),
        );
      case Right(value: final information):
        await _documents.saveDocumentNumber(state.documento);
        emit(
          state.copyWith(
            status: HomeStatus.success,
            information: information,
          ),
        );
    }
  }

  FutureOr<void> _onGetMostRecentDocumentNumber(
    GetMostRecentDocumentNumber event,
    Emitter<HomeState> emit,
  ) async {
    final document = await _documents.getMostRecentDocumentNumber();
    if (document != null) {
      emit(
        state.copyWith(
          documento: document,
        ),
      );
      _messages.add(
        UiMessage(
          type: UiMessageKind.documentNumber,
          message: document,
        ),
      );
    } else {
      _messages.add(
        UiMessage(
          type: UiMessageKind.error,
          message: "No hay documentos guardados",
        ),
      );
    }
  }
}
