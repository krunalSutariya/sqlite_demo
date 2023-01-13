import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final Widget child;
  final Color spinnerColor;
  final Widget? customLoadingIndicator;
  final LoadingIndicatorNotifier loadingStatusNotifier;

  const LoadingIndicator({
    super.key,
    required this.child,
    this.spinnerColor = Colors.white,
    required this.loadingStatusNotifier,
    this.customLoadingIndicator,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<LoadingStatus>(
      valueListenable: loadingStatusNotifier.statusNotifier,
      child: child,
      builder: (_, LoadingStatus value, Widget? builderChild) {
        Widget content;
        switch (loadingStatusNotifier.indicatorType) {
          // Overlay...
          case LoadingIndicatorType.overlay:
            final List<Widget> children = [builderChild ?? Container()];
            if (value == LoadingStatus.show) {
              children.add(loadingIndicator());
            }
            content = Stack(children: children);
            break;
          // Normal spinner...
          case LoadingIndicatorType.spinner:
            content = value == LoadingStatus.show
                ? customLoadingIndicator ??
                    const Scaffold(
                      resizeToAvoidBottomInset: false,
                      body: Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      ),
                    )
                : builderChild!;
            break;
        }
        return content;
      },
    );
  }

  // Loading Indicator...
  Widget loadingIndicator() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black26,
      body: Center(
        child: customLoadingIndicator ??
            const CircularProgressIndicator(
              color: Colors.blue,
            ),
      ),
    );
  }
}

//------ Loading Status Notifier ----//
class LoadingIndicatorNotifier extends ChangeNotifier {
  final ValueNotifier<LoadingStatus> _loadingStatus =
      ValueNotifier<LoadingStatus>(LoadingStatus.hide);

  ValueNotifier<LoadingStatus> get statusNotifier => _loadingStatus;
  LoadingIndicatorType indicatorType = LoadingIndicatorType.overlay;

  void show({LoadingIndicatorType? loadingIndicatorType}) {
    indicatorType = loadingIndicatorType ?? indicatorType;
    _loadingStatus.value = LoadingStatus.show;
    notifyListeners();
  }

  void hide() {
    _loadingStatus.value = LoadingStatus.hide;
    notifyListeners();
  }

  void disposeNotifier() {
    _loadingStatus.dispose();
  }
}

enum LoadingIndicatorType {
  overlay,
  spinner,
}

enum LoadingStatus {
  show,
  hide,
}
