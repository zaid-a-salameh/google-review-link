// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Quick NFC';

  @override
  String get appSubtitle =>
      'Ferramenta NFC rápida para links de avaliação do Google Maps';

  @override
  String get tabLink => 'Link direto';

  @override
  String get tabSearch => 'Buscar local';

  @override
  String get placeholder => 'Cole o link aqui...';

  @override
  String get trashTitle => 'Limpar texto';

  @override
  String get pasteBtn => 'Colar';

  @override
  String get convertBtn => 'Converter link';

  @override
  String get resolvingBtn => 'Processando...';

  @override
  String get searchPlaceholder => 'Nome do local e cidade...';

  @override
  String get toastEnterQuery => 'Digite o nome do local primeiro';

  @override
  String get fabGithubLabel => 'Projeto no GitHub';

  @override
  String get resultLabel => 'Link direto:';

  @override
  String get resultLabelReview => 'Link direto de avaliação:';

  @override
  String get resultLabelLocation => 'Local no Google Maps:';

  @override
  String get resultLabelCustom => 'Link direto:';

  @override
  String get linkTypePrompt => 'Tipo de link para gravar:';

  @override
  String get linkTypeReview => 'Avaliação 5 estrelas';

  @override
  String get linkTypeLocation => 'Localização no mapa';

  @override
  String get toastSwitchedToReview => 'Alternado para link de avaliação';

  @override
  String get toastSwitchedToLocation => 'Alternado para localização no mapa';

  @override
  String get btnHelpGuideTitle => 'Guia de uso e recursos';

  @override
  String get btnGuideLabel => 'Guia';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsGeneralSection => 'Preferências';

  @override
  String get settingsLanguageLabel => 'Idioma';

  @override
  String get settingsLanguageSub => 'Escolha o idioma do aplicativo';

  @override
  String get settingsLangArabic => 'العربية (Arabic)';

  @override
  String get settingsLangEnglish => 'English';

  @override
  String get settingsAboutSection => 'Sobre';

  @override
  String get settingsVersionLabel => 'Versão do aplicativo';

  @override
  String get settingsDeveloperLabel => 'Desenvolvedor e repositório';

  @override
  String get settingsBackBtn => 'Voltar';

  @override
  String get obStep1Title => 'Links inteligentes e avaliações 5★';

  @override
  String get obStep1Desc =>
      'Cole um link do Google Maps para convertê-lo instantaneamente em avaliação ou localização.';

  @override
  String get obStep2Title => 'Busca direta de locais';

  @override
  String get obStep2Desc =>
      'Digite o nome e a cidade em \'Buscar local\' para gerar o link com um toque.';

  @override
  String get obStep3Title => 'Cartões NFC, Wi-Fi e proteção';

  @override
  String get obStep3Desc =>
      'Grave links e Wi-Fi em cartões NFC e proteja-os com PIN ou bloqueio permanente.';

  @override
  String get obBtnNext => 'Avançar';

  @override
  String get obBtnStart => 'Começar';

  @override
  String get obBtnSkip => 'Pular';

  @override
  String get copyBtn => 'Copiar';

  @override
  String get copySuccess => 'Copiado!';

  @override
  String get openBtn => 'Abrir';

  @override
  String get shareBtn => 'Compartilhar';

  @override
  String get qrBtn => 'Código QR';

  @override
  String get qrModalTitle => 'QR Code de avaliação';

  @override
  String get qrModalDesc => 'Escaneie com a câmera para avaliar diretamente';

  @override
  String get qrDownloadBtn => 'Salvar QR';

  @override
  String get qrCloseBtn => 'Fechar';

  @override
  String get qrDownloaded => 'Código QR salvo';

  @override
  String get lblReadTag => 'Ler cartão';

  @override
  String get lblWifiTag => 'Cartão Wi-Fi';

  @override
  String get lblPwdLockTag => 'Bloqueio PIN';

  @override
  String get lblEraseTag => 'Apagar cartão';

  @override
  String get lblPermLockTag => 'Bloqueio permanente';

  @override
  String get wifiModalTitle => 'Configurar cartão Wi-Fi';

  @override
  String get wifiStep1Title => 'Nome da rede';

  @override
  String get wifiStep1Desc => 'Digite o nome da rede (SSID)';

  @override
  String get wifiStep2Title => 'Senha da rede';

  @override
  String get wifiStep2Desc => 'Digite a senha (ou deixe em branco se aberta)';

  @override
  String get wifiStep3Title => 'Tipo de segurança';

  @override
  String get wifiStep3Desc => 'Selecione o padrão de criptografia';

  @override
  String get wifiSsidPlaceholder => 'Nome da rede (SSID)...';

  @override
  String get wifiPasswordPlaceholder => 'Digite a senha...';

  @override
  String get wifiEncWpa => 'WPA / WPA2 / WPA3';

  @override
  String get wifiEncWpaSub => 'Padrão (Pessoal)';

  @override
  String get wifiEncWep => 'WEP';

  @override
  String get wifiEncWepSub => 'Redes antigas';

  @override
  String get wifiEncOpen => 'Rede aberta';

  @override
  String get wifiEncOpenSub => 'Sem senha';

  @override
  String get wifiNext => 'Avançar';

  @override
  String get wifiBack => 'Voltar';

  @override
  String get wifiWriteTag => 'Gravar cartão';

  @override
  String get wifiQrBtn => 'Código QR';

  @override
  String get wifiQrModalTitle => 'QR Code do Wi-Fi';

  @override
  String get wifiQrModalDesc =>
      'Escaneie com a câmera para conectar diretamente';

  @override
  String get wifiQrDownloaded => 'QR Code do Wi-Fi salvo';

  @override
  String get toastEnterSsid => 'Digite o nome da rede (SSID)';

  @override
  String get toastWifiPassMinLength =>
      'A senha deve ter pelo menos 8 caracteres';

  @override
  String get toastWifiWpaRequired =>
      'Redes WPA exigem senha de pelo menos 8 caracteres';

  @override
  String get nfcTitleWifiReady => 'Pronto para gravar Wi-Fi';

  @override
  String get nfcTitleWifiClone => 'Clonar cartão Wi-Fi';

  @override
  String get nfcTitleWifiCloneSuccess => 'Cartão Wi-Fi clonado!';

  @override
  String get nfcDescWifiReady =>
      'Aproxime o celular do cartão NFC para gravar o Wi-Fi.';

  @override
  String nfcDescWifiReadyWithSsid(String ssid) {
    return 'Aproxime o celular do cartão para gravar \"$ssid\".';
  }

  @override
  String nfcDescWifiCloneWithSsid(String ssid) {
    return 'Aproxime outro cartão do celular para copiar \"$ssid\".';
  }

  @override
  String get nfcTitleWifiSuccess => 'Cartão Wi-Fi gravado!';

  @override
  String get nfcDescWifiSuccess => 'Configurações de Wi-Fi gravadas no cartão.';

  @override
  String get nfcBtnWifiAnother => 'Gravar outro';

  @override
  String get nfcBtnWifiCloneAnother => 'Clonar outro';

  @override
  String get toastNfcWifiSuccess => 'Cartão Wi-Fi gravado com sucesso!';

  @override
  String toastNfcWifiReadSuccess(String ssid) {
    return 'Rede Wi-Fi \"$ssid\" lida! Pronto para gravar em novo cartão.';
  }

  @override
  String get nfcBtn => 'Gravar cartão NFC';

  @override
  String get nfcBtnWriteAnother => 'Gravar outro';

  @override
  String get nfcTitleReady => 'Pronto para gravar';

  @override
  String get nfcDescReady =>
      'Aproxime o celular do cartão NFC para gravar o link.';

  @override
  String get nfcTitleReadReady => 'Pronto para ler cartão';

  @override
  String get nfcDescReadReady =>
      'Aproxime o celular do cartão para ler o link.';

  @override
  String get nfcTitlePermLockReady => 'Pronto para bloquear';

  @override
  String get nfcDescPermLockReady =>
      'Aproxime o celular para aplicar o bloqueio permanente.';

  @override
  String get nfcTitlePwdLockReady => 'Pronto para bloquear';

  @override
  String get nfcDescPwdLockReady =>
      'Aproxime o celular do cartão para definir o PIN...';

  @override
  String get nfcTitlePwdUnlockReady => 'Pronto para desbloquear';

  @override
  String get nfcDescPwdUnlockReady =>
      'Aproxime o celular do cartão para desbloquear...';

  @override
  String get pwdModalTitle => 'Proteção do cartão';

  @override
  String get pwdModalTitleLock => 'Bloquear cartão';

  @override
  String get pwdModalTitleUnlock => 'Desbloquear cartão';

  @override
  String get pwdModalDesc => 'Defina um PIN para proteger o cartão';

  @override
  String get pwdModalDescLock => 'Defina um PIN para proteger o cartão';

  @override
  String get pwdModalDescUnlock => 'Digite o PIN para desbloquear';

  @override
  String get pwdHintText => 'Recomendado 4 dígitos';

  @override
  String get pwdInfoToast => 'Recomendado 4 dígitos';

  @override
  String get pwdPlaceholder => 'Digite o PIN...';

  @override
  String get pwdTabLock => 'Bloquear';

  @override
  String get pwdTabUnlock => 'Desbloquear';

  @override
  String get pwdSubmitLock => 'Bloquear cartão';

  @override
  String get pwdSubmitUnlock => 'Desbloquear cartão';

  @override
  String get pwdCancel => 'Cancelar';

  @override
  String get toastEnterPwd => 'Digite um PIN';

  @override
  String get permLockTitle => 'Bloqueio permanente';

  @override
  String get permLockDesc =>
      'Aviso: O cartão ficará permanentemente como somente leitura. Não poderá ser alterado nem apagado.';

  @override
  String get permLockConfirmBtn => 'Bloquear para sempre';

  @override
  String get permLockCancelBtn => 'Cancelar';

  @override
  String get toastNfcReadSuccess => 'Link lido e carregado com sucesso';

  @override
  String get toastNfcReadEmpty => 'Nenhum link válido encontrado no cartão';

  @override
  String get toastNfcPermLockSuccess =>
      'Cartão permanentemente bloqueado para somente leitura';

  @override
  String get toastNfcPwdLockSuccess => 'Cartão bloqueado com PIN com sucesso';

  @override
  String get toastNfcPwdUnlockSuccess => 'Cartão desbloqueado com sucesso';

  @override
  String get toastNfcWrongPwd => 'PIN incorreto ou falha ao desbloquear';

  @override
  String get toastNfcPwdUnsupported =>
      'Este cartão não suporta proteção por PIN';

  @override
  String get toastNfcAlreadyUnlocked => 'O cartão não está bloqueado';

  @override
  String get toastNfcAlreadyLocked =>
      'O cartão já possui PIN. Desbloqueie primeiro para alterar.';

  @override
  String get nfcTitleSuccess => 'Gravado com sucesso!';

  @override
  String get nfcDescSuccess => 'Cartão gravado com sucesso.';

  @override
  String get nfcTitleNext => 'Pronto para gravar';

  @override
  String get nfcDescNext => 'Aproxime outro cartão ou toque em Concluído.';

  @override
  String nfcCardsCount(int count) {
    return 'Cartões gravados: $count';
  }

  @override
  String get nfcCancel => 'Cancelar';

  @override
  String get nfcDone => 'Concluído';

  @override
  String get nfcOk => 'OK';

  @override
  String get nfcBtnLockAnother => 'Bloquear outro';

  @override
  String get nfcBtnUnlockAnother => 'Desbloquear outro';

  @override
  String get nfcTitlePwdLockSuccess => 'Cartão bloqueado';

  @override
  String get nfcDescPwdLockSuccess =>
      'O cartão está protegido contra alterações.';

  @override
  String get nfcTitlePwdUnlockSuccess => 'Cartão desbloqueado';

  @override
  String get nfcDescPwdUnlockSuccess => 'O cartão está pronto para edição.';

  @override
  String get nfcTitleAlreadyUnlocked => 'Cartão não bloqueado';

  @override
  String get nfcDescAlreadyUnlocked => 'Este cartão já está desbloqueado.';

  @override
  String get nfcTitleTagLost => 'Conexão perdida';

  @override
  String get nfcDescTagLost => 'Mantenha o celular firme sobre o cartão.';

  @override
  String get nfcTitleLocked => 'Cartão protegido';

  @override
  String get nfcTitleReadLocked => 'Leitura protegida';

  @override
  String get nfcDescReadLocked =>
      'Os dados do cartão estão protegidos contra leitura.';

  @override
  String get nfcTitleWrongPwd => 'PIN incorreto';

  @override
  String get nfcTitleAlreadyLocked => 'Cartão já bloqueado';

  @override
  String get nfcTitleCapacity => 'Capacidade excedida';

  @override
  String get nfcTitleEmptyTag => 'Cartão vazio';

  @override
  String get nfcTitlePermLockSuccess => 'Cartão permanentemente bloqueado';

  @override
  String get nfcDescPermLockSuccess =>
      'O cartão foi definido permanentemente como somente leitura.';

  @override
  String get nfcTitlePermLockStandby => 'Cartão permanentemente bloqueado!';

  @override
  String get nfcDescPermLockStandby =>
      'Pausado por segurança. Toque no ícone para reativar.';

  @override
  String nfcPermLockCount(int count) {
    return 'Bloqueados: $count';
  }

  @override
  String nfcEraseCount(int count) {
    return 'Apagados: $count';
  }

  @override
  String get nfcTitleCannotLock => 'Não é possível bloquear';

  @override
  String get nfcDescCannotLock =>
      'O cartão já é somente leitura ou incompatível.';

  @override
  String get nfcBackToPin => 'Voltar';

  @override
  String get nfcTitleDisabled => 'NFC desativado';

  @override
  String get nfcTitleNoHardware => 'NFC não suportado';

  @override
  String get nfcTitleOpFailed => 'Falha na operação';

  @override
  String get nfcDescOpFailed =>
      'A operação falhou. Mantenha o celular firme e tente novamente.';

  @override
  String get nfcTitleError => 'Falha na gravação';

  @override
  String get nfcDescLocked =>
      'Cartão com senha ou somente leitura. Desbloqueie primeiro.';

  @override
  String get nfcDescCapacity =>
      'Os dados excedem a capacidade da memória do cartão.';

  @override
  String get nfcDescUnsupported => 'Este tipo de cartão não é suportado.';

  @override
  String get nfcDescGenericError =>
      'Falha ao gravar. Mantenha o celular firme sobre o cartão.';

  @override
  String get nfcRetryBtn => 'Tentar novamente';

  @override
  String get nfcNoHardware => 'NFC não é suportado neste dispositivo';

  @override
  String get nfcDisabled => 'Ative o NFC nas configurações do telefone';

  @override
  String get nfcLocked => 'O cartão NFC está bloqueado ou é somente leitura';

  @override
  String get nfcCapacity => 'Memória insuficiente no cartão NFC';

  @override
  String get nfcUnsupported => 'Tipo de tag NFC não suportado';

  @override
  String get nfcWriteFailed => 'Erro ao gravar na tag NFC. Tente novamente.';

  @override
  String get toastPasteFirst => 'Cole um link primeiro';

  @override
  String get toastInvalid => 'Não foi possível extrair o ID do local';

  @override
  String get toastNoInternet => 'Sem conexão de rede';

  @override
  String get toastSuccess => 'Link convertido com sucesso';

  @override
  String get toastNfcWritten => 'Gravado com sucesso no cartão NFC';

  @override
  String toastNfcBatchSuccess(int count) {
    return '$count cartão(ões) NFC gravado(s) com sucesso';
  }

  @override
  String get toastCleared => 'Texto limpo';

  @override
  String get toastPasted => 'Colado da área de transferência';

  @override
  String get toastEmptyClip => 'Área de transferência vazia';

  @override
  String get toastClipDenied => 'Pressione Ctrl+V para colar';

  @override
  String get toastCopied => 'Link de avaliação copiado';

  @override
  String get toastShareCopied => 'Link copiado para compartilhar';

  @override
  String get shareTitle => 'Avaliação do Google';

  @override
  String get shareText => 'Deixe uma avaliação no Google Maps';

  @override
  String get toastHourlyLimit => 'Limite de busca por hora atingido';

  @override
  String get toastSelectSuccess => 'Link gerado';

  @override
  String get updateAvailable => 'Atualização disponível';

  @override
  String get updateReadyTitle => 'Nova versão pronta';

  @override
  String get updateCurrent => 'Atual';

  @override
  String get updateNew => 'Nova';

  @override
  String updateSize(String size) {
    return 'Tamanho: $size';
  }

  @override
  String updateDate(String date) {
    return 'Data: $date';
  }

  @override
  String get updateHighlights => 'Novidades desta versão';

  @override
  String get updateInstallBtn => 'Instalar atualização';

  @override
  String get updateViewGithub => 'Notas da versão';

  @override
  String get updateLater => 'Mais tarde';

  @override
  String get toastCheckingUpdate => 'Verificando atualizações...';

  @override
  String toastUpToDate(String version) {
    return 'O app está atualizado ($version)';
  }

  @override
  String toastUpdateFound(String version) {
    return 'Nova versão $version disponível!';
  }

  @override
  String get toastUpdateError => 'Não foi possível verificar atualizações';

  @override
  String get toastDownloadStarted => 'Baixando atualização em segundo plano...';

  @override
  String get toastQrSaveError => 'Falha ao salvar a imagem do QR';

  @override
  String get eraseModalTitle => 'Apagar cartão';

  @override
  String get eraseModalDesc =>
      'Todos os dados serão apagados e o cartão ficará vazio. Bloqueios não são afetados.';

  @override
  String get eraseConfirmBtn => 'Apagar cartão';

  @override
  String get eraseCancelBtn => 'Cancelar';

  @override
  String get nfcTitleEraseReady => 'Pronto para apagar';

  @override
  String get nfcDescEraseReady =>
      'Aproxime o celular do cartão para apagar os dados...';

  @override
  String get nfcTitleEraseSuccess => 'Cartão apagado!';

  @override
  String get nfcDescEraseSuccess => 'O cartão está vazio e pronto para uso.';

  @override
  String get nfcBtnEraseAnother => 'Apagar outro';

  @override
  String get toastNfcEraseSuccess => 'Dados do cartão apagados com sucesso';

  @override
  String get githubProjectBtn => 'GitHub';

  @override
  String get githubSupportBtn => 'Suporte';

  @override
  String get toastSupportComingSoon =>
      'A opção de suporte estará disponível em breve';

  @override
  String get settingsThemeLabel => 'Aparência';

  @override
  String get settingsThemeSub => 'Escolha o tema do aplicativo';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsThemeDark => 'Escuro';

  @override
  String get settingsThemeLight => 'Claro';
}
