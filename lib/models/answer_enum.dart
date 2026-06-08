enum AnswerOption {
  sim,
  nao,
  naoSei,
  provavelmenteSim,
  provavelmenteNao,
}

extension AnswerOptionExtension on AnswerOption {
  String get label {
    switch (this) {
      case AnswerOption.sim:
        return 'Sim';
      case AnswerOption.nao:
        return 'Não';
      case AnswerOption.naoSei:
        return 'Não sei';
      case AnswerOption.provavelmenteSim:
        return 'Provavelmente Sim';
      case AnswerOption.provavelmenteNao:
        return 'Provavelmente Não';
    }
  }
}
