import 'package:flutter/material.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

import '../services/ads_service.dart';
import '../theme/colors.dart';

class YandexBanner extends StatefulWidget {
  const YandexBanner({super.key});

  @override
  State<YandexBanner> createState() => _YandexBannerState();
}

class _YandexBannerState extends State<YandexBanner> {
  BannerAd? _bannerAd;
  bool _loaded = false;
  bool _failed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bannerAd != null) return;
    _createBanner();
  }

  @override
  void dispose() {
    _bannerAd?.destroy();
    super.dispose();
  }

  Future<void> _createBanner() async {
    if (!AdsService.instance.isSdkReady || !mounted) return;
    final widthDp = MediaQuery.of(context).size.width.toInt();
    final banner = AdsService.instance.createBannerAd(
      widthDp: widthDp,
      onAdLoaded: () {
        if (!mounted) return;
        setState(() => _loaded = true);
      },
      onAdFailedToLoad: (_) {
        if (!mounted) return;
        setState(() => _failed = true);
        debugPrint('Banner ad failed to load');
      },
    );
    if (!mounted) {
      banner.destroy();
      return;
    }
    setState(() => _bannerAd = banner);
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return Container(
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F4F8),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Реклама временно недоступна'),
            TextButton(
              onPressed: () {
                setState(() {
                  _failed = false;
                  _loaded = false;
                  _bannerAd?.destroy();
                  _bannerAd = null;
                });
                _createBanner();
              },
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    final bannerAd = _bannerAd;
    if (bannerAd == null) {
      return _buildLoadingSkeleton();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        SafeArea(
          top: false,
          child: Center(child: AdWidget(bannerAd: bannerAd)),
        ),
        if (!_loaded) _buildLoadingSkeleton(),
      ],
    );
  }

  Widget _buildLoadingSkeleton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      alignment: Alignment.center,
      child: const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}
