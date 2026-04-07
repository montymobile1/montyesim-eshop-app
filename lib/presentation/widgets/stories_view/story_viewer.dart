import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/presentation/widgets/stories_view/story_item.dart";
import "package:esim_open_source/presentation/widgets/stories_view/story_viewer_model.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:stacked/stacked.dart";

//ignore: must_be_immutable
class StoryViewer extends StatelessWidget {
  StoryViewer({
    required this.storyViewerArgs,
    super.key,
  });

  final StoryViewerArgs storyViewerArgs;

  double _dragStartY = 0;
  bool _isHolding = false;
  bool _isDraggingDown = false;

  static const String routeName = "StoryView";

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StoryViewerViewModel>.reactive(
      viewModelBuilder: () => StoryViewerViewModel(
        stories: storyViewerArgs.stories,
        autoClose: storyViewerArgs.autoClose,
        onComplete: storyViewerArgs.onComplete,
      ),
      onViewModelReady: (StoryViewerViewModel viewModel) =>
          viewModel.onViewModelReady(),
      onDispose: (StoryViewerViewModel viewModel) => viewModel.onDispose(),
      builder: (
        BuildContext context,
        StoryViewerViewModel viewModel,
        Widget? staticChild,
      ) =>
          storyView(context, viewModel),
    );
  }

  Widget storyView(
    BuildContext context,
    StoryViewerViewModel viewModel,
  ) =>
      AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        child: Scaffold(
        body: GestureDetector(
          onTapDown: (TapDownDetails details) =>
              _handleTapDown(context, viewModel, details),
          onLongPressStart: (_) {
            _isHolding = true;
            viewModel.pauseStory();
          },
          onLongPressEnd: (_) {
            _isHolding = false;
            viewModel.resumeStory();
          },
          onVerticalDragStart: (DragStartDetails details) {
            _dragStartY =
                details.localPosition.dy; // Store the starting Y position
            _isDraggingDown = false;
          },
          onVerticalDragUpdate: (DragUpdateDetails details) {
            if (details.localPosition.dy > _dragStartY) {
              _isDraggingDown = true;
            }
          },
          onVerticalDragEnd: (DragEndDetails details) =>
              _handleVerticalDragEnd(viewModel, details),
          child: Stack(
            children: <Widget>[
              PageView.builder(
                itemCount: viewModel.stories.length,
                controller: viewModel.pageController,
                onPageChanged: viewModel.onStoryChanged,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) =>
                    viewModel.stories[index].content,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: viewModel.stories[viewModel.currentIndex].buttons,
              ),
              SafeArea(
                child: PaddingWidget.applyPadding(
                  top: 20,
                  start: 10,
                  end: 10,
                  child: Row(
                    children: List<Widget>.generate(viewModel.stories.length,
                        (int index) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: LinearProgressIndicator(
                            value: _calculateProgressValue(viewModel, index),
                            backgroundColor:
                                storyViewerArgs.indicatorBackgroundColor,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              storyViewerArgs.indicatorColor,
                            ),
                            borderRadius: BorderRadius.circular(
                              storyViewerArgs.indicatorBorderRadius,
                            ),
                            minHeight: storyViewerArgs.indicatorHeight,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      );

  Future<void> _handleTapDown(
    BuildContext context,
    StoryViewerViewModel viewModel,
    TapDownDetails details,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 400), () async {
      if (_isHolding) {
        return;
      }

      if (context.mounted) {
        await viewModel.onTapDown(context, details);
      }
    });
  }

  void _handleVerticalDragEnd(
    StoryViewerViewModel viewModel,
    DragEndDetails details,
  ) {
    final bool isDownwardDrag =
        _isDraggingDown && details.primaryVelocity! > 0;

    if (isDownwardDrag) {
      viewModel.closeView();
    }
  }

  double _calculateProgressValue(StoryViewerViewModel viewModel, int index) {
    if (index < viewModel.currentIndex) {
      return 1;
    }
    if (index == viewModel.currentIndex) {
      return viewModel.progress;
    }
    return 0;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(
      DiagnosticsProperty<StoryViewerArgs>(
        "storyViewerArgs",
        storyViewerArgs,
      ),
    );
  }
}
