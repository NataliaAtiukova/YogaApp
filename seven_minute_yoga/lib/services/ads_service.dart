import 'admob_config.dart';

class AdsService {
  Future<void> initialize() async {
    // Подключение Google Mobile Ads будет добавлено позже.
    // Пока используем заглушки и локальные баннеры.
  }

  String get bannerAdUnitId => AdMobConfig.bannerAdUnitId;

  String get interstitialAdUnitId => AdMobConfig.interstitialAdUnitId;
}
