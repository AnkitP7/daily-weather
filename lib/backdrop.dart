import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

//const double _kFrontHeadingHeight = 20.0;
const double _kFrontCloseHeight = 80.0;
const double _backAppbarHeight = 40.0;

// final Tween<BorderRadius> _kFrontHeadingBevelRadius = new BorderRadiusTween(
//   begin: const BorderRadius.only(
//     topLeft: const Radius.circular(12.0),
//     topRight: const Radius.circular(12.0),
//   ),
//   end: const BorderRadius.only(
//     topLeft: const Radius.circular(_kFrontHeadingHeight),
//     topRight: const Radius.circular(_kFrontHeadingHeight),
//   ),
// );

class _Tappable extends StatefulWidget {
  final AnimationController controller;
  final AnimationStatus animationStatus;
  final Widget child;

  const _Tappable(
    this.animationStatus, {
    Key key,
    this.controller,
    this.child,
  }) : super(key: key);

  @override
  _TappableState createState() => new _TappableState();
}

class _TappableState extends State<_Tappable> {
  bool active;

  @override
  void initState() {
    super.initState();
    widget.controller.addStatusListener(_handleStatusChange);
    active = widget.controller.status == widget.animationStatus;
  }

  @override
  void dispose() {
    widget.controller.removeStatusListener(_handleStatusChange);
    super.dispose();
  }

  void _handleStatusChange(AnimationStatus status) {
    final bool value = widget.controller.status == widget.animationStatus;
    if (active != value) {
      setState(() {
        active = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new AbsorbPointer(
      absorbing: !active,
      child: new IgnorePointer(
        ignoring: !active,
        child: widget.child,
      ),
    );
  }
}

class _CrossFadeTransition extends AnimatedWidget {
  final AlignmentGeometry alignment;
  final Widget child0;
  final Widget child1;

  const _CrossFadeTransition({
    Key key,
    this.alignment = Alignment.center,
    Animation<double> progress,
    this.child0,
    this.child1,
  }) : super(key: key, listenable: progress);

  Widget build(BuildContext context) {
    final Animation<double> progress = listenable;

    final double opacity1 = new CurvedAnimation(
      parent: new ReverseAnimation(progress),
      curve: const Interval(0.5, 1.0),
    ).value;

    final double opacity2 = new CurvedAnimation(
      parent: progress,
      curve: const Interval(0.5, 1.0),
    ).value;

    return new Stack(
      alignment: alignment,
      children: <Widget>[
        new Opacity(
          opacity: opacity1,
          child: new Semantics(
            scopesRoute: true,
            explicitChildNodes: true,
            child: child1,
          ),
        ),
        new Opacity(
          opacity: opacity2,
          child: new Semantics(
            scopesRoute: true,
            explicitChildNodes: true,
            child: child0,
          ),
        ),
      ],
    );
  }
}

class _BackAppBar extends StatelessWidget {
  final Widget leading;
  final Widget trailing;
  final Widget title;

  const _BackAppBar({
    Key key,
    this.leading = const SizedBox(width: 40.0),
    @required this.title,
    this.trailing,
  })  : assert(leading != null),
        assert(title != null),
        super(key: key);

  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[
      new Container(
        alignment: Alignment.center,
        width: 56.0,
        child: leading,
      ),
      new Expanded(
        child: title,
      ),
    ];

    if (trailing != null) {
      children.add(
        new Container(
          alignment: Alignment.center,
          width: 56.0,
          child: trailing,
        ),
      );
    }

    final ThemeData themeData = Theme.of(context);

    return IconTheme.merge(
      data: themeData.primaryIconTheme,
      child: new DefaultTextStyle(
        style: themeData.primaryTextTheme.title,
        child: new SizedBox(
          height: _backAppbarHeight,
          child: new Row(children: children),
        ),
      ),
    );
  }
}

class BackDrop extends StatefulWidget {
  final Widget frontAction;
  final Widget fronTitle;
  final Widget frontHeading;
  final Widget frontLayer;
  final Widget backTitle;
  final Widget backLayer;

  const BackDrop({
    this.frontAction,
    this.backLayer,
    this.backTitle,
    this.frontHeading,
    this.fronTitle,
    this.frontLayer,
  });

  _BackDropState createState() => new _BackDropState();
}

class _BackDropState extends State<BackDrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = new GlobalKey(debugLabel: 'Backdrop');

  AnimationController _controller;
  Animation<double> _frontOpacity;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      duration: const Duration(milliseconds: 300),
      value: 1.0,
      vsync: this,
    );

    _frontOpacity = new Tween<double>(begin: 0.2, end: 1.0).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _backdropHeight {
    final RenderBox renderBox = _backdropKey.currentContext.findRenderObject();
    return math.max(
        0.0, renderBox.size.height - _backAppbarHeight - _kFrontCloseHeight);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _controller.value -=
        details.primaryDelta / (_backdropHeight ?? details.primaryDelta);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / _backdropHeight;
    if (flingVelocity < 0.0)
      _controller.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _controller.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _controller.fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0);
  }

  void _toggleFrontLayer() {
    final AnimationStatus status = _controller.status;
    final bool isOpen = status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
    _controller.fling(velocity: isOpen ? -2.0 : 2.0);
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final Animation<RelativeRect> frontRelativeRect = new RelativeRectTween(
      begin: new RelativeRect.fromLTRB(
          0.0, constraints.biggest.height - _kFrontCloseHeight, 0.0, 0.0),
      end: const RelativeRect.fromLTRB(0.0, _backAppbarHeight, 0.0, 0.0),
    ).animate(_controller);

    final List<Widget> layers = <Widget>[
      // Back layer
      new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new _BackAppBar(
            leading: widget.frontAction,
            title: new _CrossFadeTransition(
              progress: _controller,
              alignment: AlignmentDirectional.centerStart,
              child0: new Semantics(namesRoute: true, child: widget.fronTitle),
              child1: new Semantics(namesRoute: true, child: widget.backTitle),
            ),
            trailing: new IconButton(
              onPressed: _toggleFrontLayer,
              tooltip: 'Tap to view Features',
              icon: new AnimatedIcon(
                icon: AnimatedIcons.close_menu,
                progress: _controller,
              ),
            ),
          ),
          new Expanded(
            child: new _Tappable(
              AnimationStatus.dismissed,
              controller: _controller,
              child: widget.backLayer,
            ),
          ),
        ],
      ),
      // Front layer
      new PositionedTransition(
        rect: frontRelativeRect,
        child: new AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget child) {
            return new Material(
              borderRadius: const BorderRadius.only(
                topLeft: const Radius.circular(16.0),
                topRight: const Radius.circular(16.0),
              ),
              color: Theme.of(context).canvasColor,
              elevation: 12.0,
              child: child,
            );
            // return new PhysicalShape(
            //   elevation: 12.0,
            //   color: Theme.of(context).canvasColor,
            //  clipper: new ShapeBorderClipper(

            //     shape: new BeveledRectangleBorder(
            //       borderRadius:
            //           _kFrontHeadingBevelRadius.lerp(_controller.value),
            //     ),
            //   ),
            //   child: child,
            // );
          },
          child: new _Tappable(
            AnimationStatus.completed,
            controller: _controller,
            child: new FadeTransition(
              opacity: _frontOpacity,
              child: widget.frontLayer,
            ),
          ),
        ),
      ),
    ];

    // The front "heading" is a (typically transparent) widget that's stacked on
    // top of, and at the top of, the front layer. It adds support for dragging
    // the front layer up and down and for opening and closing the front layer
    // with a tap. It may obscure part of the front layer's topmost child.
    if (widget.frontHeading != null) {
      layers.add(
        new PositionedTransition(
          rect: frontRelativeRect,
          child: new ExcludeSemantics(
            child: new Container(
              alignment: Alignment.topLeft,
              child: new GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _toggleFrontLayer,
                onVerticalDragUpdate: _handleDragUpdate,
                onVerticalDragEnd: _handleDragEnd,
                child: widget.frontHeading,
              ),
            ),
          ),
        ),
      );
    }

    return new Stack(
      key: _backdropKey,
      children: layers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: _buildStack);
  }
}
